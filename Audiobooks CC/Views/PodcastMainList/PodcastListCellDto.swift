//
//  PodcastListCellDto.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-23.
//

import Foundation

struct PodcastListCellDto {
    let id: String
    let title: String
    let publisher: String
    let description: String
    let thumbnail: String
    let isFavourite: Bool
    
    init(podcast: PodcastServerData, isFavorite: Bool) {
        self.id = podcast.id
        self.title = podcast.title
        self.publisher = podcast.publisher
        self.description = podcast.description
        self.thumbnail = podcast.thumbnail
        self.isFavourite = isFavorite
    }
}
