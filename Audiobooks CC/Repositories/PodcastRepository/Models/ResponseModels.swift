//
//  ResponseModels.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-21.
//

import Foundation

// Dev Note: I used ai to help generate the boilerplate models below
// MARK: - PodcastResponse
struct PodcastResponse: Codable, Sendable {
    let id: Int
    let hasNext: Bool
    let previousPageNumber: Int?
    let hasPrevious: Bool
    let name: String
    let nextPageNumber: Int?
    let pageNumber: Int
    let total: Int
    let listennotesURL: String
    let podcasts: [PodcastData]
    let parentID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case hasNext = "has_next"
        case previousPageNumber = "previous_page_number"
        case hasPrevious = "has_previous"
        case name
        case nextPageNumber = "next_page_number"
        case pageNumber = "page_number"
        case total
        case listennotesURL = "listennotes_url"
        case podcasts
        case parentID = "parent_id"
    }
}

// MARK: - Podcast
struct PodcastData: Codable, Sendable {
    let hasGuestInterviews: Bool
    let updateFrequencyHours: Int?
    let email: String?
    let id: String
    let listenScore: Int?
    let listenScoreGlobalRank: String?
    let isClaimed: Bool
    let extra: ExtraLinksData
    let explicitContent: Bool
    let itunesID: Int?
    let rss: String?
    let description: String
    let publisher: String
    let totalEpisodes: Int
    let hasSponsors: Bool
    let earliestPubDateMS: Int64?
    let latestPubDateMS: Int64?
    let image: String
    let country: String
    let type: String
    let genreIDs: [Int]
    let language: String
    let latestEpisodeID: String?
    let listennotesURL: String
    let title: String
    let audioLengthSec: Int?
    let website: String?
    let lookingFor: LookingForData
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case hasGuestInterviews = "has_guest_interviews"
        case updateFrequencyHours = "update_frequency_hours"
        case email, id
        case listenScore = "listen_score"
        case listenScoreGlobalRank = "listen_score_global_rank"
        case isClaimed = "is_claimed"
        case extra
        case explicitContent = "explicit_content"
        case itunesID = "itunes_id"
        case rss, description, publisher
        case totalEpisodes = "total_episodes"
        case hasSponsors = "has_sponsors"
        case earliestPubDateMS = "earliest_pub_date_ms"
        case latestPubDateMS = "latest_pub_date_ms"
        case image, country, type
        case genreIDs = "genre_ids"
        case language
        case latestEpisodeID = "latest_episode_id"
        case listennotesURL = "listennotes_url"
        case title
        case audioLengthSec = "audio_length_sec"
        case website, lookingFor = "looking_for"
        case thumbnail
    }
}

// MARK: - ExtraLinks
struct ExtraLinksData: Codable, Sendable {
    let spotifyURL: String?
    let amazonMusicURL: String?
    let linkedinURL: String?
    let url1: String?
    let twitterHandle: String?
    let wechatHandle: String?
    let instagramHandle: String?
    let patreonHandle: String?
    let url2: String?
    let facebookHandle: String?
    let url3: String?
    let youtubeURL: String?

    enum CodingKeys: String, CodingKey {
        case spotifyURL = "spotify_url"
        case amazonMusicURL = "amazon_music_url"
        case linkedinURL = "linkedin_url"
        case url1
        case twitterHandle = "twitter_handle"
        case wechatHandle = "wechat_handle"
        case instagramHandle = "instagram_handle"
        case patreonHandle = "patreon_handle"
        case url2
        case facebookHandle = "facebook_handle"
        case url3
        case youtubeURL = "youtube_url"
    }
}

// MARK: - LookingFor
struct LookingForData: Codable, Sendable {
    let cohosts: Bool
    let sponsors: Bool
    let crossPromotion: Bool
    let guests: Bool

    enum CodingKeys: String, CodingKey {
        case cohosts, sponsors
        case crossPromotion = "cross_promotion"
        case guests
    }
}
