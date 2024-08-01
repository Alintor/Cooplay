//
//  UserService.swift
//  Cooplay
//
//  Created by Alexandr on 28/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import Firebase
import FirebaseCore
import GoogleSignIn
import AuthenticationServices

enum UserServiceError: Error {
    
    case fetchProfile
    case editProfile
    case unknownError
    case unhandled(error: Error)
}

extension UserServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .fetchProfile: return Localizable.errorsUserServiceFetchProfile()
        case .editProfile: return Localizable.errorsUserServiceEditProfile()
        case .unknownError: return Localizable.errorsUnknown()
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

protocol UserServiceType {
    
    func searchUser(_ searchValue: String, completion: @escaping (Result<[User], UserServiceError>) -> Void)
    func searchUser(_ searchValue: String) async throws -> [User]
    func updateNickName(_ name: String) async throws
    func uploadNewAvatar(_ image: UIImage) async throws
    func deleteAvatar(path: String, needClear: Bool) async throws
    func updateNotificationsInfo(_ info: NotificationsInfo)
}


final class UserService {
    
    private let storage: Storage
    private let firebaseAuth: Auth
    private let firestore: Firestore
    private var userListener: ListenerRegistration?
    
    // MARK: - Init
    
    init(storage: Storage, firebaseAuth: Auth, firestore: Firestore) {
        self.storage = storage
        self.firebaseAuth = firebaseAuth
        self.firestore = firestore
    }
    
    // MARK: - Private Methods
    
    private func fetchProfile(completion: @escaping (Result<Profile, UserServiceError>) -> Void) {
        userListener = nil
        guard let currentUser = firebaseAuth.currentUser else { return }
        
        userListener = firestore.collection("Users").document(currentUser.uid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
            }
            if let data = snapshot?.data(),
                var profile = try? FirestoreDecoder.decode(data, to: Profile.self) {
                profile.email = currentUser.email
                completion(.success(profile))
            } else {
                completion(.failure(.fetchProfile))
            }
        }
    }
    
    func updateNickName(_ name: String) async throws {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        
        try await firestore.collection("Users").document(userId).updateData(["name" : name])
        let snapshot =  try await firestore.collection("Events").whereField(FieldPath(["members", userId, "id"]), isEqualTo: userId).getDocuments()
        
        let batch = firestore.batch()
        for document in snapshot.documents {
            batch.updateData(["members.\(userId).name" : name], forDocument: document.reference)
        }
        try await batch.commit()
    }
    
    func uploadNewAvatar(_ image: UIImage) async throws {
        guard
            let userId = firebaseAuth.currentUser?.uid,
            let imageData = image.imageDataForUpload
        else { return }
        
        let avatarRef = storage.reference().child("avatars/\(userId).jpg")
        _ = try await avatarRef.putDataAsync(imageData)
        let url = try await avatarRef.downloadURL()
        let avatarPath = url.absoluteString
        
        try await firestore.collection("Users").document(userId).updateData(["avatarPath" : avatarPath])
        let snapshot =  try await firestore.collection("Events").whereField(FieldPath(["members", userId, "id"]), isEqualTo: userId).getDocuments()
        let batch = firestore.batch()
        for document in snapshot.documents {
            batch.updateData(["members.\(userId).avatarPath" : avatarPath], forDocument: document.reference)
        }
        try await batch.commit()
    }
    
    func deleteAvatar(path: String, needClear: Bool) async throws {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        
        let avatarRef = storage.reference(forURL: path)
        try await avatarRef.delete()
        
        guard needClear else { return }
        
        try await firestore.collection("Users").document(userId).updateData(["avatarPath" : FieldValue.delete()])
        let snapshot =  try await firestore.collection("Events").whereField(FieldPath(["members", userId, "id"]), isEqualTo: userId).getDocuments()
        let batch = firestore.batch()
        for document in snapshot.documents {
            batch.updateData(["members.\(userId).avatarPath" : FieldValue.delete()], forDocument: document.reference)
        }
        try await batch.commit()
    }
    
    private func registerNotificationToken(_ token: String) {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        
        firestore.collection("Users").document(userId).updateData(["notificationsInfo.tokens.\(UIDevice.current.systemName)" : token])
    }
    
    private func removeNotificationToken() {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        
        firestore.collection("Users").document(userId).updateData(["notificationsInfo.tokens.\(UIDevice.current.systemName)" : FieldValue.delete()])
    }
    
}

extension UserService: Middleware {
    
    func perform(store: Store, action: StoreAction) {
        switch action {
        case .successAuthentication:
            fetchProfile { result in
                switch result {
                case .success(let profile):
                    store.dispatch(.updateProfile(profile))
                case .failure(let error):
                    if store.state.value.authentication.isAuthenticated {
                        store.dispatch(.showNetworkError(error))
                    }
                }
            }
            
        case .logout:
            userListener = nil
            removeNotificationToken()
            
        case .registerNotificationToken(let token):
            registerNotificationToken(token)
            
        default: break
        }
    }
}

extension UserService: UserServiceType {
    
    func searchUser(_ searchValue: String, completion: @escaping (Result<[User], UserServiceError>) -> Void) {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        firestore.collection("Users").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
                return
            }
            let users = snapshot?.documents.compactMap({
                return try? FirestoreDecoder.decode($0.data(), to: Profile.self)
            })
            let filteredUsers = users?.filter({
                $0.name.lowercased().contains(searchValue.lowercased()) && $0.id != userId
            })
            completion(.success(filteredUsers?.map({ $0.user }) ?? []))
        }
        
    }
    
    func searchUser(_ searchValue: String) async throws -> [User] {
        guard let userId = firebaseAuth.currentUser?.uid else { throw UserServiceError.unknownError }
        
        let snapshot = try await firestore.collection("Users").getDocuments()
        let users = snapshot.documents.compactMap({
            return try? FirestoreDecoder.decode($0.data(), to: Profile.self)
        })
        let filteredUsers = users.filter({
            $0.name.lowercased().contains(searchValue.lowercased()) && $0.id != userId
        })
        return filteredUsers.map({ $0.user })
    }
    
    func updateNotificationsInfo(_ info: NotificationsInfo) {
        guard 
            let userId = firebaseAuth.currentUser?.uid,
            let infoData = info.dictionary
        else { return }
        
        var data = [String: Any]()
        for (key, value) in infoData {
            data["notificationsInfo.\(key)"] = value
        }
        firestore.collection("Users").document(userId).updateData(data)
    }
    
}
