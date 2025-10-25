//
//  WebClientRequester.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-22.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }

class WebClient {
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func get<T: Decodable>(url: URL,
                           parameters: [String: String]? = nil,
                           responseType: T.Type) async throws -> T {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let parameters = parameters {
            components?.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        guard let getUrl = components?.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: getUrl)
        request.httpMethod = "GET"
        // TODO: Add key in prod
        request.addValue("", forHTTPHeaderField: "X-ListenAPI-Key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request, delegate: nil)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            // TODO: Handle more errors...ie 400
            throw URLError(.badServerResponse)
        }

        return try decodeResponse(T.self, data: data)
    }
    
    private func decodeResponse<T: Decodable>(_ type: T.Type, data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            Logger.log(error.localizedDescription)
            throw URLError(.cannotDecodeContentData)
        }
    }
}
