//
//  ExampleTestLog.swift
//  AppLogsExample
//
//  Created by Hanno Gödecke on 16.07.24.
//

import Foundation
import os.log 

@objc
public class ExampleTestLog: NSObject {
  
  let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "applogs.example", category: "App")
  
  @objc
  public func testLog() {
    os_log("[AppName] sending test log", log: log) 
  }
}
