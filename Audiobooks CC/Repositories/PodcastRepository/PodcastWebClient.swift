//
//  PodcastWebClient.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-21.
//

import Foundation
import PodcastAPI


/*
 The PodcastAPI client has its own error type enum. I think it would be a good idea to log them appropriately.
 e.g., Connection or rate-limit errors could be logged in internal client logs,
 but auth-related errors could be more pressing and logged in a way that notifies developers better.
 
 Status Codes - https://www.listennotes.com/api/docs/?lang=kotlin&test=1#get-api-v2-best_podcasts
 200 success
 400 something wrong on your end (client side errors), e.g., missing required parameters.
 401 wrong api key, or your account is suspended.
 404 endpoint does not exist, or podcast / episode not exist.
 429 for FREE plan, exceeding the quota limit; or for all plans, sending too many requests too fast and exceeding the rate limit.
 500 something wrong on our end (unexpected server errors).
*/

class PodcastWebClient: PodcastRepository {
    enum PodcastApiParameters: String {
        case page = "page"
        case region = "region"
        case safeMode = "safe_mode"
    }
    
    private let client: PodcastApiType
    
    init(client: PodcastApiType = PodcastAPI.Client(apiKey: "", synchronousRequest: false)) {
        self.client = client
    }
    
    func fetchBestPodcasts(page: Int) async throws -> BestPodcastsServerResponse {
        try await withCheckedThrowingContinuation { continuation in
            
            var parameters: [String: String] = [:]
            parameters[PodcastApiParameters.page.rawValue] = String(page)
            // should be matching user region to listennotes supported regions found in the following API, for now just use US region https://www.listennotes.com/api/docs/?lang=kotlin&test=1#get-api-v2-regions
            parameters[PodcastApiParameters.region.rawValue] = "us"
            parameters[PodcastApiParameters.safeMode.rawValue] = "0"
            
            // TODO: Chris - this SPM package api is mehhh, in hindsight I would write my own urlsession implementation
            // Using generics in order to pass the expected response type so that it could be a reusable solution for more than a single API call
            // Also their client fetch class "ApiResponse" is not unit test/mock friendly, since it doesn't provide the best podcast response data in a concrete class or struct but just json string.
            client.fetchBestPodcasts(parameters: parameters) { response in
                if let error = response.error {
                    Logger.log(error.localizedDescription)
                    continuation.resume(throwing: error)
                } else {
                    if let json = response.toJson() {
                        do {
                            let response = try self.decodeResponse(BestPodcastsServerResponse.self, data: json.rawData())
                            continuation.resume(returning: response)
                        } catch {
                            Logger.log(error.localizedDescription)
                            continuation.resume(throwing: error)
                        }
                    } else {
                        let error = URLError(.cannotDecodeRawData)
                        Logger.log(error.localizedDescription)
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
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
