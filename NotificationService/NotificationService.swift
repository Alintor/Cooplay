//
//  NotificationService.swift
//  NotificationService
//
//  Created by Alexandr on 11.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import UserNotifications
import Intents

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        guard
            let bestAttemptContent = bestAttemptContent,
            let intent = handleUserInfo(bestAttemptContent.userInfo)
        else {
            contentHandler(request.content)
            return
        }
        
        do {
            let updatedContent = try bestAttemptContent.updating(from: intent)
            contentHandler(updatedContent)
                
        } catch {
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func handleUserInfo(_ userInfo: [AnyHashable: Any]) -> INSendMessageIntent? {
        guard let typeString = userInfo["type"] as? String, let notificationType = NotificationType(rawValue: typeString) else { return nil }
        
        switch notificationType {
        case .statusChange,
             .takeEventOwner,
             .deleteEvent,
             .addReaction:
            guard
                let eventJson = userInfo["event"] as? String,
                let eventData =  eventJson.data(using: .utf16),
                let event = try? JSONDecoder().decode(Event.self, from: eventData)
            else { return nil }
            
            let user = event.me
            if
                let coverPath = event.game.coverPath,
                let fileUrl = downloadImageLink(coverPath, fileName: event.game.slug+".png"),
                let attachment = try? UNNotificationAttachment.init(identifier: event.game.slug+".png", url: fileUrl, options: nil)
            {
                bestAttemptContent?.attachments = [attachment]
            }
            if
                let avatarPath = user.avatarPath,
                let aps = userInfo["aps"] as? [AnyHashable: Any],
                let alert = aps["alert"] as? [AnyHashable: Any],
                let titleLoc = alert["title-loc-key"] as? String,
                let titleArgs = alert["title-loc-args"] as? [String],
                let avatarURL = downloadImageLink(avatarPath, fileName: user.id),
                let avatarData = try? Data(contentsOf: avatarURL)
            {
                let handle = INPersonHandle(value: nil, type: .unknown)
                let avatar = INImage(imageData: avatarData)
                let sender = INPerson(
                    personHandle: handle,
                    nameComponents: nil,
                    displayName: String(format: NSLocalizedString(titleLoc, comment: ""), arguments: titleArgs),
                    image: avatar,
                    contactIdentifier: nil,
                    customIdentifier: nil
                )
                let intent = INSendMessageIntent(
                    recipients: nil,
                    outgoingMessageType: .outgoingMessageText,
                    content: nil,
                    speakableGroupName: nil,
                    conversationIdentifier: event.id,
                    serviceName: nil,
                    sender: sender,
                    attachments: nil
                )
                return intent
            }
            
        default: break
        }
        return nil
    }
    
    private func downloadImageLink(_ link: String, fileName: String) -> URL? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        let fileURL: URL = tmpSubFolderURL.appendingPathComponent(fileName)
        if let _ = try? Data(contentsOf: fileURL) {
            return fileURL
        }
        do {
            let data = try Data(contentsOf: URL(string: link)!)
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            try data.write(to: fileURL)
            return fileURL
        } catch let error {
            print("error \(error)")
        }
        return nil
    }

}
