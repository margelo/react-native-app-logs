//
//  ExampleTestLog.swift
//  AppLogsExample
//
//  Created by Hanno Gödecke on 16.07.24.
//

import Foundation
import os.log
import UserNotifications
import UIKit

@objc
public class ExampleTestLog: NSObject {

  let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "applogs.example", category: "App")

  @objc
  public func testLog() {
    os_log("[AppName] sending test log", log: log)
  }

  @objc
  public func requestNotificationPermission() {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
          if granted {
            os_log("[AppName] Notification permission granted", log: self.log )
              self.getNotificationSettings()
          } else {
            os_log("[AppName] Notification permission denied", log: self.log )
          }
      }
  }

  @objc
  func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print ("[AppName] Notification settings: \(settings)" )
          DispatchQueue.main.async {
              UIApplication.shared.registerForRemoteNotifications()
          }
      }
  }
}
