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
    var application: NSApplication = NSApplication.shared
    var statusBarItem: NSStatusItem?
    let menu = NSMenu()


    func applicationDidFinishLaunching(_ notification: Notification) {
        menu.delegate = self;
        
        let app = getAppInfo()
        let contentView = ContentView(appName: app.appName, architecture: app.architecture, appIcon: app.appImage)
        
        let menuItem = NSMenuItem()
        let view = NSHostingView(rootView: contentView)
        view.frame = NSRect(x: 0, y: 0, width: 200, height: 100)

        menuItem.view = view
        menu.addItem(menuItem)
        
        menu.addItem(NSMenuItem(title: "Quit Quotes", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let itemImage = NSImage(named: "processor-icon")
        itemImage?.isTemplate = true
        statusBarItem?.button?.image = itemImage
        statusBarItem?.menu = menu
    }
    
    
    func menuWillOpen(_ menu: NSMenu) {
        let app = getAppInfo()
        let contentView = ContentView(appName: app.appName, architecture: app.architecture, appIcon: app.appImage)

        let menuItem = NSMenuItem()
        let view = NSHostingView(rootView: contentView)
        view.frame = NSRect(x: 0, y: 0, width: 200, height: 100)

        menuItem.view = view
        menu.removeAllItems()
        menu.addItem(menuItem)
        menu.addItem(NSMenuItem(title: "Quit Silicon Info", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }

    
    func getAppInfo() -> RunningApplication{
        let frontAppName = NSWorkspace.shared.frontmostApplication?.localizedName
        let frontAppImage = NSWorkspace.shared.frontmostApplication?.icon
        let architectureInt = NSWorkspace.shared.frontmostApplication?.executableArchitecture
            
        var architecture = ""
        switch architectureInt {
        case NSBundleExecutableArchitectureARM64:
            architecture = "arm64 - Apple Silicon"
        case NSBundleExecutableArchitectureI386:
            architecture = "x86 - Intel 32-bit"
        case NSBundleExecutableArchitectureX86_64:
            architecture = "x86-64 - Intel 64-bit"
        case NSBundleExecutableArchitecturePPC:
            architecture = "ppc32 - PowerPC 32-bit"
        case NSBundleExecutableArchitecturePPC64:
            architecture = "ppc64 - PowerPC 64-bit"
        default:
            architecture = "Unknown"
        }
        return RunningApplication(appName: frontAppName!, architecture: architecture, appImage: frontAppImage!)
    }
}
