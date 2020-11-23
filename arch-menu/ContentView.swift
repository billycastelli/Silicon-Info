//
//  ContentView.swift
//  arch-menu
//
//  Created by Billy Castelli on 11/22/20.
//

import SwiftUI

struct ContentView: View {
    let appName: String
    let architecture: String
    let appIcon: NSImage
    var body: some View {
        VStack {
            Text(Image(nsImage: appIcon))
            Text(appName).font(.title)
            Text(architecture)

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appName: "", architecture: "", appIcon: NSImage(imageLiteralResourceName: "ProcessorIcon"))
    }
}
