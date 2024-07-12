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

    @objc public func setupLogStore() {
        do {
            logStore = try OSLogStore(scope: .currentProcessIdentifier)
        } catch {
            print("Failed to create OSLogStore: \(error)")
        }
    }

    @objc public func getNewLogs(since startTime: Date, completion: @escaping ([String]) -> Void) {
        guard let logStore = logStore else {
            completion([])
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
            
            completion(entries)
        }
    }
}
