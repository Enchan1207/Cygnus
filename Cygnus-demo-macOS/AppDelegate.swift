//
//  AppDelegate.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/11.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let replWindowController = ReplWindowController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        replWindowController.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }


}

