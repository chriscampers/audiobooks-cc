//
//  PodcastListViewModel.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-21.
//

import Combine
import SwiftUI

@MainActor final class PodcastListViewModel: ObservableObject {
    enum State {
        case initialLoading
        case loaded([PodcastListCellDto])
        case error(error: PodcastListViewErrors)
    }
    
    enum PodcastListViewErrors: String, Identifiable {
        case noPodcastsLoaded
        case issueLoadingNewPage
        
        var id: String { self.rawValue }
    }
    
    // Used to present state related pages (initial loading, loaded, error)
    @Published var state: State
    // Used to track if we are in the middle of page fetch, displays loading indicator if needed
    @Published var isPageLoading = false
    @Published var alertError: PodcastListViewErrors?
    
    private let podcastRepository: PodcastRepository
    private let favoritePodcastRepository: FavoritePodcastRepository
    
    // Keeps track of
    private var loadedPodcastList: [PodcastListCellDto] = []
    // Used to track what page to load next
    private var lastLoadedPage = 0
    // Used to help handle preemptive page loading
    private var largestShownIndex: Int = 0
    // Used to track if we can load another page
    private var isLastPage: Bool = false


    init(podcastRepository: PodcastRepository,
         favoritePodcastRepository: FavoritePodcastRepository) {
        self.state = .initialLoading
        self.podcastRepository = podcastRepository
        self.favoritePodcastRepository = favoritePodcastRepository
    }
    
    func onAppear() async {
        if lastLoadedPage == 0 {
            await loadNextPage()
        }

        updateFavorites()
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
            await loadNextPage()
        }
    }
    
    func loadNextPage() async {
        isPageLoading = true
        defer { isPageLoading = false }
        
        // Hop off main actor for network request, this is non blocking while we await response
        let syncTask = Task.detached { [self] in
            return try await podcastRepository.fetchBestPodcasts(page: lastLoadedPage + 1)
        }
        
        do {
            // Jump back to main to handle response and update UI
            let response = try await syncTask.value
            try await handleNewPageResponse(response)
        } catch {
            // TODO: Chris - update error
            handleErrors(error: error)
        }
    }
    
    private func handleNewPageResponse(_ response: BestPodcastsServerResponse) async throws {
        lastLoadedPage = response.pageNumber
        isLastPage = response.hasNext
        
        // Map response data to view dtos
        let newDtos = mapPageToDto(pagePodcastList: response.podcasts)
        loadedPodcastList.append(contentsOf: newDtos)
        
        // DEV NOTE: Delay This is for fun - give the impression of a slow network response
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        state = .loaded(loadedPodcastList)
    }
    
    private func handleErrors(error: Error) {
        Logger.log(error.localizedDescription)
        
        var viewError: PodcastListViewErrors
        if loadedPodcastList.count == 0 {
            viewError = .noPodcastsLoaded
            state = .error(error: .noPodcastsLoaded)
        } else {
            viewError = .issueLoadingNewPage
        }
        
        alertError = viewError
    }
    
    private func mapPageToDto(pagePodcastList: [PodcastServerData]) -> [PodcastListCellDto] {
        return pagePodcastList.map { podcast in
            let isFavorite = favoritePodcastRepository.isPodcastFavorited(podcast.id)
            return PodcastListCellDto(podcast: podcast, isFavorite: isFavorite)
        }
    }
    
    // This could be more efficient, ie: reload only when specific cell changes, and also binding data to the details view.
    // For this use case, it doesn't seem needed as overhead is not huge but still something to consider.
    // Also my thought process was that because we are persisting favorites, if a user add/removes a podcast from favorites
    // This view should refetch the favorite directly from the source instead of updating based on an in-memory object because if there was ever
    // issues in the repository layer with persisting a favorite, it shouldn't be hidden from the user.
    private func updateFavorites() {
        if loadedPodcastList.count == 0 {
            return
        }
        
        var updatedPodcastList = [PodcastListCellDto]()
        for podcast in loadedPodcastList {
            let isFavorite = favoritePodcastRepository.isPodcastFavorited(podcast.id)
            let pCast = PodcastListCellDto(podcast: podcast, isFavorite: isFavorite)
            updatedPodcastList.append(pCast)
        }
        state = .loaded(updatedPodcastList)
    }
}
