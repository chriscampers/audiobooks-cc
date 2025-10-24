//
//  MockFavoritePodcastRepository.swift
//  Audiobooks CCTests
//
//  Created by Chris Campanelli on 2025-10-24.
//

import Foundation
@testable import Audiobooks_CC

@MainActor class MockFavoritePodcastRepository: FavoritePodcastRepository {
    private var favoritePodcastIds: Set<String> = []

    func isPodcastFavorited(_ podcastId: String) -> Bool {
        return favoritePodcastIds.contains(podcastId)
    }
    
    func addFavoritePodcast(_ podcastId: String) {
        favoritePodcastIds.insert(podcastId)
    }
    
    func removeFavoritePodcast(_ podcastId: String) {
        favoritePodcastIds.remove(podcastId)
    }
}

@MainActor class MockPodcastRepository: PodcastRepository {
    var shouldThrowError = false
    var response: BestPodcastsServerResponse?
    enum MockError: Error {
        case simulatedError
        case noResponse
    }
    
    func fetchBestPodcasts(page: Int) async throws -> BestPodcastsServerResponse {
        if shouldThrowError {
            throw MockError.simulatedError
        }
        guard let response else { throw MockError.noResponse }
        return response
    }
}
