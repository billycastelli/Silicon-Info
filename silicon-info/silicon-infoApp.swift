//
//  SiliconInfoApp.swift
//  silicon-info
//
//  Created by Billy Castelli on 11/22/20.
//

import SwiftUI

struct RunningApplication {
    let appName: String
    let architecture: String
    let appImage: NSImage
    let processorIcon: NSImage
}

@main
struct SiliconInfoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    // Set notification for active applications
    override init(){
        super.init()
        NSWorkspace.shared.notificationCenter.addObserver(self,
            selector: #selector(iconSwitcher(notification:)),
            name: NSWorkspace.didActivateApplicationNotification,
            object:nil)

    }
    var application: NSApplication = NSApplication.shared
    var statusBarItem: NSStatusItem?
    let menu = NSMenu()
    
    // Run function when application first opens
    func applicationDidFinishLaunching(_ notification: Notification) {
        menu.delegate = self;
        
        // Grab application information from frontmost application
        let app = getApplicationInfo(application: NSWorkspace.shared.frontmostApplication!)
        
        // Set view
        let contentView = ContentView(appName: app.appName, architecture: app.architecture, appIcon: app.appImage)
        let menuItem = NSMenuItem()
        let view = NSHostingView(rootView: contentView)
        view.frame = NSRect(x: 0, y: 0, width: 200, height: 100)
        menuItem.view = view
        menu.addItem(menuItem)
        menu.addItem(NSMenuItem(title: "Quit Silicon Info", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        // Set initial app icon
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let itemImage = app.processorIcon;
        itemImage.isTemplate = true
        statusBarItem?.button?.image = itemImage
        statusBarItem?.menu = menu
    }
    
    
    // Run function when menu bar icon is clicked
    func menuWillOpen(_ menu: NSMenu) {
        // Grab application information from frontmost application
        let app = getApplicationInfo(application: NSWorkspace.shared.frontmostApplication!)
        
        // Set view
        let contentView = ContentView(appName: app.appName, architecture: app.architecture, appIcon: app.appImage)
        let menuItem = NSMenuItem()
        let view = NSHostingView(rootView: contentView)
        view.frame = NSRect(x: 0, y: 0, width: 200, height: 100)
        menuItem.view = view
        menu.removeAllItems()
        menu.addItem(menuItem)
        menu.addItem(NSMenuItem(title: "Quit Silicon Info", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        // Update icon
        let itemImage = app.processorIcon;
        itemImage.isTemplate = true
        statusBarItem?.button?.image = itemImage
    }
    
    // Run function when a new application is sent to front
    @objc func iconSwitcher(notification: NSNotification) {
        let runningApplication = notification.userInfo!["NSWorkspaceApplicationKey"] as! NSRunningApplication
        let app = getApplicationInfo(application: runningApplication)
        let itemImage = app.processorIcon;
        itemImage.isTemplate = true
        statusBarItem?.button?.image = itemImage
    }
    
    func getApplicationInfo(application: NSRunningApplication) ->RunningApplication{
        let frontAppName = application.localizedName
        let frontAppImage = application.icon
        let architectureInt = application.executableArchitecture
        
        var architecture = ""
        var processorIcon = NSImage()
        switch architectureInt {
        case NSBundleExecutableArchitectureARM64:
            architecture = "arm64 - Apple Silicon"
            processorIcon = NSImage(named: "processor-icon")!
        case NSBundleExecutableArchitectureI386:
            architecture = "x86 - Intel 32-bit"
            processorIcon = NSImage(named: "processor-icon-empty")!
        case NSBundleExecutableArchitectureX86_64:
            architecture = "x86-64 - Intel 64-bit"
            processorIcon = NSImage(named: "processor-icon-empty")!
        case NSBundleExecutableArchitecturePPC:
            architecture = "ppc32 - PowerPC 32-bit"
            processorIcon = NSImage(named: "processor-icon-empty")!
        case NSBundleExecutableArchitecturePPC64:
            architecture = "ppc64 - PowerPC 64-bit"
            processorIcon = NSImage(named: "processor-icon-empty")!
        default:
            architecture = "Unknown"
            processorIcon = NSImage(named: "processor-icon-empty")!
        }
        return RunningApplication(appName: frontAppName!, architecture: architecture, appImage: frontAppImage!, processorIcon: processorIcon)
    }
}
