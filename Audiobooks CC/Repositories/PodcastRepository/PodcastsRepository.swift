//
//  PodcastsRepository.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-21.
//

protocol PodcastRepository: Sendable {
    func fetchBestPodcasts(page: Int) async throws -> BestPodcastsServerResponse
}
