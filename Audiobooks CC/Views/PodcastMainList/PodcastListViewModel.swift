//
//  PodcastListViewModel.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-21.
//

import Combine
import SwiftUI

enum PodcastListViewErrors {
    case noConnection
}

@MainActor final class PodcastListViewModel: ObservableObject {
    enum State {
        case loading
        case loaded([PodcastListCellDto])
        case error(error: PodcastListViewErrors)
    }
    
    enum alert {
        case newPageError
    }
    
    @Published var state: State
    @Published var isEndOfList: Bool = false
    
    private let podcastRepository: PodcastRepository
    private var loadedPodcastList: [PodcastListCellDto] = []
    private var lastLoadedPage = 0

    init(podcastRepository: PodcastRepository) {
        self.state = .loading
        self.podcastRepository = podcastRepository
        Task {
            await loadPage()
        }
    }
    
    private func loadPage() async {
        do {
            let response = try await podcastRepository.fetchBestPodcasts(page: lastLoadedPage + 1)
            isEndOfList = response.nextPageNumber == nil
            lastLoadedPage = response.pageNumber
            let newDtos = mapPageToDto(pagePodcastList: response.podcasts)
            
            loadedPodcastList.append(contentsOf: newDtos)
            state = .loaded(loadedPodcastList)
        } catch {
            // TODO: Chris - update error
            state = .error(error: .noConnection)
        }
    }
    
    private func mapPageToDto(pagePodcastList: [PodcastData]) -> [PodcastListCellDto] {
        return pagePodcastList.map { podcast in
            // TODO: Chris check is favourite
            PodcastListCellDto(podcast: podcast, isFavorite: false)
        }
    }
}

// TODO: Chris move to new file
struct PodcastListCellDto {
    let id: String
    let title: String
    let publisher: String
    let description: String
    let thumbnail: String
    let isFavourite: Bool
    
    init(podcast: PodcastData, isFavorite: Bool) {
        self.id = podcast.id
        self.title = podcast.title
        self.publisher = podcast.publisher
        self.description = podcast.description
        self.thumbnail = podcast.thumbnail
        self.isFavourite = isFavorite
    }
}
