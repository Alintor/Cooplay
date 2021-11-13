//
//  ProfileInteractorInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import Foundation

protocol ProfileInteractorInput: class {

    func logout()
    func fetchProfile(completion: @escaping (Result<Profile, ProfileError>) -> Void)
}
