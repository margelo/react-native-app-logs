//
//  NotificationService.swift
//  NotificationService
//
//  Created by Hanno Gödecke on 16.07.24.
//

import AppLogs
import Intents
import os.log
import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "applogs.example.hanno", category: "App")

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var logStoreHelper: AppLogs = .init()

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
        os_log("[AppName] [NotificationService] serviceExtensionTimeWillExpire", log: log)
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
  
    deinit {
      logStoreHelper.interceptLogs(appGroup: "group.applogs.example")
    }
}
