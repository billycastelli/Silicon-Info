//
//  arch_menuApp.swift
//  arch-menu
//
//  Created by Billy Castelli on 11/22/20.
//

import SwiftUI

@main
struct arch_menuApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    var application: NSApplication = NSApplication.shared
    var statusBarItem: NSStatusItem?
    let menu = NSMenu()


    func applicationDidFinishLaunching(_ notification: Notification) {
        menu.delegate = self;
        
        let runningApp: [String:Any] = getAppInfo()
        let contentView = ContentView(appName: runningApp["appName"] as! String, architecture:  runningApp["architecture"] as! String, appIcon: runningApp["appImage"] as! NSImage)
        
        let menuItem = NSMenuItem()
        let view = NSHostingView(rootView: contentView)
        view.frame = NSRect(x: 0, y: 0, width: 175, height: 125)
        
        menuItem.view = view
        menu.addItem(menuItem)
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem?.button?.title = "🖥"
        statusBarItem?.menu = menu
    }
    
    
    func menuWillOpen(_ menu: NSMenu) {
        let runningApp: [String:Any] = getAppInfo()
        let contentView = ContentView(appName: runningApp["appName"] as! String, architecture:  runningApp["architecture"] as! String, appIcon: runningApp["appImage"] as! NSImage)
        
        let menuItem = NSMenuItem()
        let view = NSHostingView(rootView: contentView)
        view.frame = NSRect(x: 0, y: 0, width: 200, height: 100)

        menuItem.view = view
        menu.removeAllItems()
        menu.addItem(menuItem)
    }
    
    
    func getAppInfo() -> Dictionary<String, Any>{
        let frontAppName = NSWorkspace.shared.frontmostApplication?.localizedName
        let frontAppImage = NSWorkspace.shared.frontmostApplication?.icon
        let architectureInt = NSWorkspace.shared.frontmostApplication?.executableArchitecture
            
        var architecture = ""
        switch architectureInt {
        case NSBundleExecutableArchitectureARM64:
            architecture = "ARM64 - Apple Silicon"
        case NSBundleExecutableArchitectureI386:
            architecture = "I386 - Intel 32 bit"
        case NSBundleExecutableArchitectureX86_64:
            architecture = "X86_64 - Intel 64 bit"
        case NSBundleExecutableArchitecturePPC:
            architecture = "PPC - 32 bit"
        case NSBundleExecutableArchitecturePPC:
            architecture = "PPC - 64 bit"
        default:
            architecture = "Unknown"
        }
        return ["appName": frontAppName!, "appImage": frontAppImage as Any, "architecture": architecture]
    }
}

