//
//  PodcastWebRepository.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-21.
//

import Foundation
import PodcastAPI

class PodcastWebRepository: PodcastRepository {
    enum PodcastApiParameters: String {
        case page = "page"
        case region = "region"
        case safeMode = "safe_mode"
    }
    
    private let client: WebClient
    
    init(client: WebClient = WebClient()) {
        self.client = client
    }
    
    func fetchBestPodcasts(page: Int) async throws -> BestPodcastsServerResponse {
        // should be matching user region to listennotes supported regions found in the following API, for now just use US region https://www.listennotes.com/api/docs/?lang=kotlin&test=1#get-api-v2-regions
        // Can also match language param make sure podcast can be listened to in the users langauge
        var parameters: [String: String] = [:]
        parameters[PodcastApiParameters.region.rawValue] = "us"
        parameters[PodcastApiParameters.safeMode.rawValue] = "0"
        parameters[PodcastApiParameters.page.rawValue] = String(page)
        
        return try await client.get(url: Constants.listnotesBestPodcastsUrl,
                                       parameters: parameters,
                                       responseType: BestPodcastsServerResponse.self)
    }

    private func decodeResponse<T: Decodable>(_ type: T.Type, data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            throw URLError(.cannotDecodeContentData)
        }
    }
}

actor Logger: Sendable {
    static func log(_ string: String) {
        // Mock for client/user logs
        if true {
            print(string)
        }
    }
}
