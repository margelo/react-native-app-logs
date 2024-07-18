//
//  NotificationService.swift
//  NotificationService
//
//  Created by Hanno Gödecke on 16.07.24.
//

import UserNotifications
import os.log
import Intents
import OSLogStoreHelper

class NotificationService: UNNotificationServiceExtension {
  
  let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "applogs.example.hanno", category: "App")

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
  var logStoreHelper: OSLogStoreHelper = OSLogStoreHelper()
  
  override init() {
    super.init()
    
    logStoreHelper.setupWatcher()
  }

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
      os_log("[AppName] [NotificationService] didReceive() - received notification", log: log)
      // let a = OSLogStoreHelper()
      // a.setupLogStore()
      // a.getNewLogs(since: Date.init(timeIntervalSince1970: 0)) { logs in
      //   print(logs)
      // }
      
      // Your array of strings
      /*let stringsToPass = ["String1", "String2", "String3"]
      
      // Save the array to UserDefaults in the shared App Group
      let userDefaults = UserDefaults(suiteName: "group.applogs.example")
      userDefaults?.set(stringsToPass, forKey: "logs")
      userDefaults?.synchronize()
      
      // Post a Darwin notification
      let notificationName = "io.margelo.newLogsAvailable"
      os_log("Posting notification: %{public}@", log: .default, type: .debug, notificationName)
      CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                           CFNotificationName(notificationName as CFString),
                                           nil, nil, true)*/
      
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
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
