//
//  FavouritePodcastRepository.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-21.
//

import Foundation

protocol FavouritePodcastRepository: Sendable {
    func isPodcastFavorited(_ podcastId: String) -> Bool
    func addFavoritePodcast(_ podcastId: String)
    func removeFavoritePodcast(_ podcastId: String)
}

class UserPreferences: FavouritePodcastRepository {
    static let shared = UserPreferences()
    
    /// TODO: This should be persisted using some sort of storage container that writes to the disk ie: SQLite and
    /// synced to the server but since that is out of scope I implented a Set of id's that are held in memory using a
    /// set since its O(1) for lookup/adding/removing
    private var favouritePodcastIds: Set<String> = []

    func isPodcastFavorited(_ podcastId: String) -> Bool {
        return favouritePodcastIds.contains(podcastId)
    }
    
    func addFavoritePodcast(_ podcastId: String) {
        favouritePodcastIds.insert(podcastId)
    }
    
    func removeFavoritePodcast(_ podcastId: String) {
        favouritePodcastIds.remove(podcastId)
    }
}
