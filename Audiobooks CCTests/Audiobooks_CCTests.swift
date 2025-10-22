//
//  Audiobooks_CCTests.swift
//  Audiobooks CCTests
//
//  Created by Chris Campanelli on 2025-10-21.
//

import Testing
@testable import Audiobooks_CC
import PodcastAPI

struct Audiobooks_CCTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}

// MARK: - Mock Error
enum MockError: Error, Equatable {
    case mockFailure
}

// MARK: - Mock API Client
final class MockPodcastApiClient: PodcastApiType {
    var shouldReturnError = false
    var mockResponse: ApiResponse?
    
    func fetchBestPodcasts(parameters: [String : String], completion: @escaping (ApiResponse) -> ()) {
        if shouldReturnError {
            let response = ApiResponse(request: nil,
                                       data: nil,
                                       response: nil,
                                       httpError: MockError.mockFailure,
                                       apiError: nil)
            completion(response)
        } else if let mockResponse = mockResponse {
            completion(mockResponse)
        } else {
            let response = ApiResponse(request: nil,
                                       data: nil,
                                       response: nil,
                                       httpError: nil,
                                       apiError: nil)
            completion(response)
        }
    }
}
