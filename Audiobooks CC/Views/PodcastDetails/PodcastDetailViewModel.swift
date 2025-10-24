//
//  PodcastDetailViewModel.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-24.
//

import Combine
import Foundation
import SwiftUI

@MainActor
class PodcastDetailViewModel: ObservableObject {
    @Published var podcast: PodcastDetailCellDto
    private var favoriteRepository: FavoritePodcastRepository
    
    init(podcast: PodcastDetailCellDto,
         favoriteRepository: FavoritePodcastRepository) {
        self.podcast = podcast
        self.favoriteRepository = favoriteRepository
    }
    
    func toggleFavorite() {
        if !podcast.isFavorite {
            favoriteRepository.addFavoritePodcast(podcast.id)
            podcast = PodcastListCellDto(podcast: podcast, isFavorite: true)
        } else {
            favoriteRepository.removeFavoritePodcast(podcast.id)
            podcast = PodcastListCellDto(podcast: podcast, isFavorite: false)
        }
    }
}
