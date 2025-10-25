//
//  Audiobooks_CCApp.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-21.
//

import SwiftUI

@main
struct Audiobooks_CCApp: App {
    var body: some Scene {
        WindowGroup {
            PodcastListView(podcastRepository: PodcastWebRepository(), favoritesRepository: UserPreferences.shared)
        }
    }
}
