//
//  AppLogs.swift
//  react-native-app-logs
//
//  Created by Kiryl Ziusko on 09/07/2024.
//

import Foundation
import OSLog

extension DateFormatter {
    func apply(closure: (DateFormatter) -> Void) -> DateFormatter {
        closure(self)
        return self
    }
}

@available(iOS 15.0, *)
extension OSLogEntryLog.Level: CustomStringConvertible {
    public var description: String {
        switch self {
        case .undefined:
            return "undefined"
        case .debug:
            return "debug"
        case .info:
            return "info"
        case .notice:
            return "notice"
        case .error:
            return "error"
        case .fault:
            return "fault"
        default:
            return "unknown"
        }
    }
}

@available(iOS 15.0, *)
@objc
public class AppLogs: NSObject {
    private var logStore: OSLogStore?
    private static var lastLogCheckTime = Date(timeIntervalSince1970: 0)
    private let formatter = DateFormatter().apply {
        $0.timeZone = TimeZone(abbreviation: "UTC");
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    }
    
    @objc public func interceptLogs(appGroup: String) {
        do {
            logStore = try OSLogStore(scope: .currentProcessIdentifier)
        } catch {
            print("Failed to create OSLogStore: \(error)")
        }
        
        checkForNewLogs(appGroup: appGroup)
    }
    
    @objc func checkForNewLogs(appGroup: String) {
        print("Checking logs from: \(AppLogs.lastLogCheckTime)")
        getNewLogs(since: AppLogs.lastLogCheckTime) { logs in
            let userDefaults = UserDefaults(suiteName: appGroup)
            userDefaults?.set(logs, forKey: "logs")
            userDefaults?.synchronize()
            
            // Post a Darwin notification
            let notificationName = "io.margelo.newLogsAvailable"
            os_log("Posting notification: %{public}@", log: .default, type: .debug, notificationName)
            CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                                 CFNotificationName(notificationName as CFString),
                                                 nil, nil, true)
        }
        AppLogs.lastLogCheckTime = Date()
    }

    @objc public func getNewLogs(since startTime: Date, completion: @escaping ([NSDictionary]) -> Void) {
        guard let logStore = logStore else {
            completion([])
            return
        }

        DispatchQueue.global().async {
            let start = CFAbsoluteTimeGetCurrent()
            let now = Date()
            let predicate = NSPredicate(format: "date >= %@ AND date <= %@", startTime as NSDate, now as NSDate)
            var entries: [NSDictionary] = []
            
            do {
                let allEntries = try logStore.getEntries(matching: predicate)
                
                for entry in allEntries {
                    if let logEntry = entry as? OSLogEntryLog {
                        entries.append([
                            "message": logEntry.composedMessage,
                            "timestamp": self.formatter.string(from: logEntry.date),
                            "process": logEntry.process,
                            "pid": logEntry.processIdentifier,
                            "tid": logEntry.threadIdentifier,
                            "level": logEntry.level.description,
                        ])
                    }
                }
            } catch {
                print("Failed to get log entries: \(error)")
            }
            
            let diff = CFAbsoluteTimeGetCurrent() - start
            print("Took \(diff) seconds Logs: \(entries.count)")
            
            completion(entries)
        }
    }
}
