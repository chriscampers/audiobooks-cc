//
//  PodcastListViewModelTests.swift
//  Audiobooks CCTests
//
//  Created by Chris Campanelli on 2025-10-24.
//

import Foundation
import Testing
@testable import Audiobooks_CC

@MainActor
struct PodcastListViewModelTests {

    // MARK: - Properties
    var mockPodcastRepository: MockPodcastRepository
    var mockFavoriteRepository: MockFavoritePodcastRepository
    var viewModel: PodcastListViewModel

    init() {
        mockPodcastRepository = MockPodcastRepository()
        mockFavoriteRepository = MockFavoritePodcastRepository()
        viewModel = PodcastListViewModel(
            podcastRepository: mockPodcastRepository,
            favoritePodcastRepository: mockFavoriteRepository
        )
    }

    // MARK: - Tests

    @Test("Initial state is initialLoading")
    func testInitialState_isLoading() async throws {
        if case .initialLoading = viewModel.state {
            #expect(true)
        } else {
            Issue.record("Expected .initialLoading state, got \(viewModel.state)")
        }
    }

    @Test("Successful page load sets state to .loaded")
    func testloadNextPageSetsLoadedState() async throws {
        let podcast = PodcastServerData.mock()
        mockPodcastRepository.response = BestPodcastsServerResponse(
            id: 93,
            hasNext: false,
            previousPageNumber: nil,
            hasPrevious: false,
            name: "Business",
            nextPageNumber: nil,
            pageNumber: 1,
            total: 1,
            listennotesURL: "https://mock.com",
            podcasts: [podcast],
            parentID: nil
        )

        await viewModel.loadNextPage()

        switch viewModel.state {
        case .loaded(let cells):
            #expect(cells.count == 1)
            #expect(cells.first?.id == podcast.id)
        default:
            Issue.record("Expected .loaded state, got \(viewModel.state)")
        }
    }

    @Test("Failed page load sets .error and alertError")
    func testLoadNextPageSetsErrorWhenFailure() async throws {
        mockPodcastRepository.shouldThrowError = true

        await viewModel.loadNextPage()

        switch viewModel.state {
        case .error(let error):
            #expect(error == .noPodcastsLoaded)
        default:
            Issue.record("Expected .error state on failure")
        }

        #expect(viewModel.alertError == .noPodcastsLoaded)
    }

    @Test("onAppear updates favorites correctly")
    func testUpdateFavorites() async throws {
        let podcast = PodcastServerData.mock()
        mockPodcastRepository.response = BestPodcastsServerResponse.mock(podcasts: [podcast])

        await viewModel.loadNextPage()
        mockFavoriteRepository.addFavoritePodcast(podcast.id)

        await viewModel.onAppear() // triggers updateFavorites()

        switch viewModel.state {
        case .loaded(let cells):
            #expect(cells.first?.isFavorite == true)
        default:
            Issue.record("Expected updated favorites state")
        }
    }

    @Test("Loading multiple pages appends results")
    func loadNextPageMultiplePages() async throws {
        // First page
        let page1 = PodcastServerData.mock(id: "1", title: "P1", publisher: "A")
        mockPodcastRepository.response = BestPodcastsServerResponse(
            id: 1,
            hasNext: true,
            previousPageNumber: nil,
            hasPrevious: false,
            name: "Category",
            nextPageNumber: 2,
            pageNumber: 1,
            total: 1,
            listennotesURL: "",
            podcasts: [page1],
            parentID: nil
        )
        await viewModel.loadNextPage()

        // Second page
        let page2 = PodcastServerData.mock(id: "2", title: "P2", publisher: "B")
        mockPodcastRepository.response = BestPodcastsServerResponse(
            id: 2,
            hasNext: false,
            previousPageNumber: 1,
            hasPrevious: true,
            name: "Category",
            nextPageNumber: nil,
            pageNumber: 2,
            total: 2,
            listennotesURL: "",
            podcasts: [page2],
            parentID: nil
        )
        await viewModel.loadNextPage()

        switch viewModel.state {
        case .loaded(let cells):
            #expect(cells.count == 2)
            #expect(cells.map(\.id) == ["1", "2"])
        default:
            Issue.record("Expected .loaded with 2 podcasts")
        }
    }

    @Test("Subsequent error after successful load shows alert only")
    func handleError_afterLoad_showsAlertButKeepsState() async throws {
        let podcast = PodcastServerData.mock(id: "1", title: "Mock", publisher: "Tester")
        mockPodcastRepository.response = BestPodcastsServerResponse.mock(podcasts: [podcast])

        await viewModel.loadNextPage()
        mockPodcastRepository.shouldThrowError = true

        await viewModel.loadNextPage()

        #expect(viewModel.alertError == .issueLoadingNewPage)

        switch viewModel.state {
        case .loaded:
            #expect(true)
        default:
            Issue.record("Expected to remain in .loaded state after secondary error")
        }
    }
}
