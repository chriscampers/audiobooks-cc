//
//  MockUrlSession.swift
//  Audiobooks CCTests
//
//  Created by Chris Campanelli on 2025-10-25.
//

@testable import Audiobooks_CC
import Foundation

final class MockURLSession: URLSessionProtocol {
    var dataToReturn: Data
    var errorToThrow: Error?
    var response: URLResponse?
    
    init(dataToReturn: Data) {
        self.dataToReturn = dataToReturn
    }
    
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        if let errorToThrow {
            throw errorToThrow
        }
        return(dataToReturn, response ?? URLResponse())
    }
}

@MainActor
final class MockWebClient: WebClient {
    var lastCalledURL: URL?
    var lastParameters: [String: String]?
    var responseToReturn: Any?
    var errorToThrow: Error?
    
    override func get<T: Decodable>(url: URL,
                                    parameters: [String: String]? = nil,
                                    responseType: T.Type) async throws -> T {
        lastCalledURL = url
        lastParameters = parameters
        
        if let errorToThrow {
            throw errorToThrow
        }
        
        if let response = responseToReturn as? T {
            return response
        }
        throw URLError(.badServerResponse)
    }
}
