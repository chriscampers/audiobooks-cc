//
//  PodcastsRepositoryTests.swift
//  Audiobooks CCTests
//
//  Created by Chris Campanelli on 2025-10-25.
//

@testable import Audiobooks_CC
import Testing

@MainActor
struct PodcastsRepositoryTests {

    @Test
    func testFetchBestPodcastsReturnsResponse() async throws {
        let mockClient = MockWebClient()
        let expectedResponse = BestPodcastsServerResponse.mock()

        mockClient.responseToReturn = expectedResponse
        let sut = PodcastWebRepository(client: mockClient)
        
        let result = try await sut.fetchBestPodcasts(page: 1)
        
        #expect(result.id == 93)
        #expect(result.name == "Mock Category")
    }
}
