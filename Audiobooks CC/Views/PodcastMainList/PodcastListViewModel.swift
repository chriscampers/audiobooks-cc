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
        case initialLoading
        case loaded([PodcastListCellDto])
        case error(error: PodcastListViewErrors)
    }
    
    enum errorAlert {
        case newPageError
    }
    
    @Published var state: State
    @Published var isPageLoading = false
    
    private let podcastRepository: PodcastRepository
    private let favoritePodcastRepository: FavouritePodcastRepository
    
    private var loadedPodcastList: [PodcastListCellDto] = []
    private var lastLoadedPage = 0
    private var largestShownIndex: Int = 0
    private var isLastPage: Bool = false


    init(podcastRepository: PodcastRepository, favoritePodcastRepository: FavouritePodcastRepository) {
        self.state = .initialLoading
        self.podcastRepository = podcastRepository
        self.favoritePodcastRepository = favoritePodcastRepository
        
        Task {
            await loadNewPage()
        }
    }
    
    func cellDidAppear(index: Int) async {
        if isPageLoading || !isLastPage {
            return
        }
        
        if index > largestShownIndex {
            largestShownIndex = index
        }
        
        // If we are nearing the end of the list preemptively load more cells to make
        // the list loading feel seamless
        let shouldLoadMorePodcasts = largestShownIndex >= loadedPodcastList.count - 5
        if shouldLoadMorePodcasts {
            await loadNewPage()
        }
    }
    
    private func loadNewPage() async {
        isPageLoading = true
        defer { isPageLoading = false }
        
        // Hop off main actor for network request, this is non blocking while we await response
        let syncTask = Task.detached { [self] in
            return try await podcastRepository.fetchBestPodcasts(page: lastLoadedPage + 1)
        }
        
        do {
            // Jump back to main to handle respone and update UI
            let response = try await syncTask.value
            try await handleNewPageResonse(response)
        } catch {
            // TODO: Chris - update error
            handleErrors(error: error)
        }
    }
    
    private func handleNewPageResonse(_ response: BestPodcastsServerResponse) async throws {
        lastLoadedPage = response.pageNumber
        isLastPage = response.hasNext
        
        // Map response data to view dtos
        let newDtos = mapPageToDto(pagePodcastList: response.podcasts)
        loadedPodcastList.append(contentsOf: newDtos)
        
        // DEV NOTE: This is for fun - give the impression of a slow network response
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        state = .loaded(loadedPodcastList)
    }
    
    private func handleErrors(error: Error) {
        if loadedPodcastList.count == 0 {
            // SUDO Code: We don't have any podcasts to shown or available to show, we know we errored out, show error page. Maybe add a reload button?
        } else if loadedPodcastList.count > 0 {
            // SUDO Code: We already have podcasts being show, log error and show alert if needer
        }
        
        // Update vm state
        state = .error(error: .noConnection)
    }
    
    private func mapPageToDto(pagePodcastList: [PodcastServerData]) -> [PodcastListCellDto] {
        return pagePodcastList.map { podcast in
            let isFavorite = favoritePodcastRepository.isPodcastFavorited(podcast.id)
            return PodcastListCellDto(podcast: podcast, isFavorite: isFavorite)
        }
    }
}
