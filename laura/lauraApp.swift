//
//  lauraApp.swift
//  laura
//
//  Created by senyo on 2/21/24.
//

import SwiftUI

@main


struct lauraApp: App {

    let max_height:CGFloat = 960
    let max_width:CGFloat = 1536
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(
                                    minWidth: 400, maxWidth: max_width,
                                    minHeight: 600, maxHeight:max_height)
            
        }
        .defaultSize(CGSize(width: max_width, height: max_height))
        .windowResizability(.contentSize)
    }
}



