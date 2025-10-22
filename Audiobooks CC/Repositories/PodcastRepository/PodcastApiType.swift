//
//  PodcastApiType.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-22.
//

import Foundation
import PodcastAPI

protocol PodcastApiType {
    func fetchBestPodcasts(parameters: [String: String], completion: @escaping (ApiResponse) -> ())
}

extension Client: PodcastApiType { }
