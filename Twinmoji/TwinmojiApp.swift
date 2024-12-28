//
//  TwinmojiApp.swift
//  Twinmoji
//
//  Created by tonystark on 12/24/24.
//

import SwiftUI
import SwiftData

@main
struct TwinmojiApp: App {

    var body: some Scene {
        WindowGroup {
            MenuView()
                .preferredColorScheme(.light)
        }
    }
}
