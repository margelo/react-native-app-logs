//
//  OSLogStoreHelper.swift
//  react-native-app-logs
//
//  Created by Kiryl Ziusko on 09/07/2024.
//

import Foundation
import OSLog

@available(iOS 15.0, *)
@objc
public class OSLogStoreHelper: NSObject {
    private var logStore: OSLogStore?
    private static var onNewLogs: (([String]) -> Void)? = nil

    @objc public init(onNewLogs: @escaping ([String]) -> Void) {
        do {
            logStore = try OSLogStore(scope: .currentProcessIdentifier)
        } catch {
            print("Failed to create OSLogStore: \(error)")
        }
        OSLogStoreHelper.onNewLogs = onNewLogs
        
        super.init()
        
        // Register for Darwin notifications
        let notificationName = "io.margelo.newLogsAvailable"
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        let observer = UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
        
        CFNotificationCenterAddObserver(center,
                                        observer,
                                        { (center, observer, name, object, userInfo) in
                                            OSLogStoreHelper.handleNewData()
                                        },
                                        notificationName as CFString,
                                        nil,
                                        .deliverImmediately)
    }
    
    static func handleNewData() {
        // os_log("Received notification of new data", log: .default, type: .debug)
        
        // Retrieve the array from UserDefaults
        let userDefaults = UserDefaults(suiteName: "group.applogs.example")
        if let passedStrings = userDefaults?.array(forKey: "logs") as? [String] {
            print("Received strings: \(passedStrings)")
            OSLogStoreHelper.onNewLogs?(passedStrings)
            // remove temporary data
            userDefaults?.set([], forKey: "logs")
            userDefaults?.synchronize()
        }
    }
    
    deinit {
        // Unregister the observer when the AppDelegate is deallocated
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        let observer = UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
        CFNotificationCenterRemoveObserver(center, observer, nil, nil)
    }

    @objc public func getNewLogs(since startTime: Date) {
        guard let logStore = logStore else {
            OSLogStoreHelper.onNewLogs?([])
            return
        }

        DispatchQueue.global().async {
            let start = CFAbsoluteTimeGetCurrent()
            let now = Date()
            let predicate = NSPredicate(format: "date >= %@ AND date <= %@", startTime as NSDate, now as NSDate)
            var entries: [String] = []
            
            do {
                let allEntries = try logStore.getEntries(matching: predicate)
                
                for entry in allEntries {
                    if let logEntry = entry as? OSLogEntryLog {
                        entries.append(logEntry.composedMessage)
                    }
                }
            } catch {
                print("Failed to get log entries: \(error)")
            }
            
            let diff = CFAbsoluteTimeGetCurrent() - start
            print("Took \(diff) seconds Logs: \(entries.count)")
            
            OSLogStoreHelper.onNewLogs?(entries)
        }
    }
}
