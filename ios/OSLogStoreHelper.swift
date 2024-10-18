//
//  OSLogStoreHelper.swift
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
public class OSLogStoreHelper: NSObject {
    private static var appGroupName: String?
    private var logStore: OSLogStore?
    private static var onNewLogs: (([NSDictionary]) -> Void)? = nil
    private let formatter = DateFormatter().apply {
        $0.timeZone = TimeZone(abbreviation: "UTC")
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    }

    @objc public init(onNewLogs: @escaping ([NSDictionary]) -> Void) {
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
                                        { _, _, _, _, _ in
                                            OSLogStoreHelper.handleNewData()
                                        },
                                        notificationName as CFString,
                                        nil,
                                        .deliverImmediately)
    }

    static func handleNewData() {
        let userDefaults = UserDefaults(suiteName: appGroupName)
        if let passedStrings = userDefaults?.array(forKey: "logs") as? [NSDictionary] {
            print("Received strings: \(passedStrings)")
            OSLogStoreHelper.onNewLogs?(passedStrings)
            // remove temporary data
            userDefaults?.set([], forKey: "logs")
            userDefaults?.synchronize()
        }
    }

    deinit {
        // Unregister the observer when the module is deallocated
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        let observer = UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
        CFNotificationCenterRemoveObserver(center, observer, nil, nil)
    }
    
    @objc public func setAppGroupName(_ appGroupName: String) {
        OSLogStoreHelper.appGroupName = appGroupName
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

            OSLogStoreHelper.onNewLogs?(entries)
        }
    }
}
