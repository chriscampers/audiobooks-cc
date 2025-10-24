//
//  FavoritePodcastRepository.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-21.
//

import Foundation

protocol FavoritePodcastRepository: Sendable {
    func isPodcastFavorited(_ podcastId: String) -> Bool
    func addFavoritePodcast(_ podcastId: String)
    func removeFavoritePodcast(_ podcastId: String)
}

@MainActor class UserPreferences: FavoritePodcastRepository {
    static let shared = UserPreferences()
    
    /// DEV NOTE: This should be persisted using a more appropriate storage container ie: SQLite and
    /// synced to the server but since a little out of scope I implemented userdefaults container to simulate a db
    private var favoritePodcastIds: UserDefaults = UserDefaults(suiteName: "com.podcast.favorites")!

    func isPodcastFavorited(_ podcastId: String) -> Bool {
        return favoritePodcastIds.string(forKey: podcastId) != nil
    }
    
    func addFavoritePodcast(_ podcastId: String) {
        favoritePodcastIds.set(podcastId, forKey: podcastId)
    }
    
    func removeFavoritePodcast(_ podcastId: String) {
        favoritePodcastIds.removeObject(forKey: podcastId)
    }
}
