//
//  PodcastDetailViewModelTests.swift
//  Audiobooks CCTests
//
//  Created by Chris Campanelli on 2025-10-24.
//

@testable import Audiobooks_CC
import Testing

@MainActor
struct PodcastDetailViewModelTests {

    @Test("toggleFavorite() adds podcast when not favorited")
       func toggleFavoriteAddsPodcast() async throws {
           let mockRepo = MockFavoritePodcastRepository()
           let dto = PodcastDetailCellDto.init(podcast: PodcastServerData.mock(), isFavorite: false)
           let viewModel = PodcastDetailViewModel(podcast: dto, favoriteRepository: mockRepo)

           viewModel.toggleFavorite()

           #expect(viewModel.podcast.isFavorite == true)
           #expect(await mockRepo.isPodcastFavorited(dto.id) == true)
       }

       @Test("toggleFavorite() removes podcast when already favorited")
       func toggleFavoriteRemovesPodcast() async throws {
           let mockRepo = MockFavoritePodcastRepository()
           let dto = PodcastDetailCellDto.init(podcast: PodcastServerData.mock(), isFavorite: true)
           let viewModel = PodcastDetailViewModel(podcast: dto, favoriteRepository: mockRepo)
           mockRepo.addFavoritePodcast(dto.id)

           viewModel.toggleFavorite()

           #expect(viewModel.podcast.isFavorite == false)
           #expect(await mockRepo.isPodcastFavorited(dto.id) == false)
       }

       @Test("toggleFavorite() flips favorite state each time")
       func toggleFavoriteTogglesMultipleInteractions() async throws {
           let mockRepo = MockFavoritePodcastRepository()
           let dto = PodcastDetailCellDto.init(podcast: PodcastServerData.mock(), isFavorite: false)
           let viewModel = PodcastDetailViewModel(podcast: dto, favoriteRepository: mockRepo)

           viewModel.toggleFavorite()
           #expect(viewModel.podcast.isFavorite == true)

           viewModel.toggleFavorite()
           #expect(viewModel.podcast.isFavorite == false)
           
           viewModel.toggleFavorite()
           #expect(viewModel.podcast.isFavorite == true)
           
           viewModel.toggleFavorite()
           #expect(viewModel.podcast.isFavorite == false)
       }
}
