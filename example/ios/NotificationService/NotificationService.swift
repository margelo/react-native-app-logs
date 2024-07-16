//
//  NotificationService.swift
//  NotificationService
//
//  Created by Hanno Gödecke on 16.07.24.
//

import UserNotifications
import os.log
import Intents

class NotificationService: UNNotificationServiceExtension {
  
  let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "applogs.example.NotificationService", category: "NotificationService")

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
      os_log("[AppName] [NotificationService] didReceive() - received notification", log: log)
      
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
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

}
