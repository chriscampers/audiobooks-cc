//
//  ServerDataMocks.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-24.
//

@testable import Audiobooks_CC
import Foundation

extension BestPodcastsServerResponse {
    static func mock(
        id: Int = 93,
        hasNext: Bool = false,
        previousPageNumber: Int? = nil,
        hasPrevious: Bool = false,
        name: String = "Mock Category",
        nextPageNumber: Int? = nil,
        pageNumber: Int = 1,
        total: Int = 10,
        listennotesURL: String = "https://www.listennotes.com/mock-category",
        podcasts: [PodcastServerData] = (1...5).map { index in
            PodcastServerData.mock(id: "mock-\(index)", title: "Mock Podcast \(index)")
        },
        parentID: Int? = nil
    ) -> BestPodcastsServerResponse {
        BestPodcastsServerResponse(
            id: id,
            hasNext: hasNext,
            previousPageNumber: previousPageNumber,
            hasPrevious: hasPrevious,
            name: name,
            nextPageNumber: nextPageNumber,
            pageNumber: pageNumber,
            total: total,
            listennotesURL: listennotesURL,
            podcasts: podcasts,
            parentID: parentID
        )
    }
}

extension PodcastServerData {
    static func mock(
        id: String = UUID().uuidString,
        title: String = "Mock Podcast Title",
        publisher: String = "Mock Publisher",
        description: String = "A test description of a podcast used for unit testing and UI previews.",
        image: String = "https://example.com/mock-image.jpg",
        thumbnail: String = "https://example.com/mock-thumbnail.jpg",
        listennotesURL: String = "https://www.listennotes.com/mock",
        country: String = "US",
        language: String = "English",
        type: String = "episodic",
        genreIDs: [Int] = [93],
        totalEpisodes: Int = 100,
        listenScore: Int? = 95,
        listenScoreGlobalRank: String? = "10",
        isClaimed: Bool = true,
        hasGuestInterviews: Bool = false,
        updateFrequencyHours: Int? = 24,
        email: String? = "mock@podcast.com",
        explicitContent: Bool = false,
        itunesID: Int? = 123456,
        rss: String? = "https://example.com/rss",
        hasSponsors: Bool = false,
        earliestPubDateMS: Int64? = 1_600_000_000_000,
        latestPubDateMS: Int64? = 1_700_000_000_000,
        latestEpisodeID: String? = "episode_1",
        audioLengthSec: Int? = 3600,
        website: String? = "https://example.com",
        extra: ExtraLinksServerData = .mock(),
        lookingFor: LookingForServerData = .mock()
    ) -> PodcastServerData {
        PodcastServerData(
            hasGuestInterviews: hasGuestInterviews,
            updateFrequencyHours: updateFrequencyHours,
            email: email,
            id: id,
            listenScore: listenScore,
            listenScoreGlobalRank: listenScoreGlobalRank,
            isClaimed: isClaimed,
            extra: extra,
            explicitContent: explicitContent,
            itunesID: itunesID,
            rss: rss,
            description: description,
            publisher: publisher,
            totalEpisodes: totalEpisodes,
            hasSponsors: hasSponsors,
            earliestPubDateMS: earliestPubDateMS,
            latestPubDateMS: latestPubDateMS,
            image: image,
            country: country,
            type: type,
            genreIDs: genreIDs,
            language: language,
            latestEpisodeID: latestEpisodeID,
            listennotesURL: listennotesURL,
            title: title,
            audioLengthSec: audioLengthSec,
            website: website,
            lookingFor: lookingFor,
            thumbnail: thumbnail
        )
    }
}

extension LookingForServerData {
    static func mock(
        cohosts: Bool = false,
        sponsors: Bool = false,
        crossPromotion: Bool = true,
        guests: Bool = false
    ) -> LookingForServerData {
        LookingForServerData(
            cohosts: cohosts,
            sponsors: sponsors,
            crossPromotion: crossPromotion,
            guests: guests
        )
    }
}

extension ExtraLinksServerData {
    static func mock(
        spotifyURL: String? = "https://open.spotify.com/show/mockpodcast",
        amazonMusicURL: String? = "https://music.amazon.com/podcasts/mockpodcast",
        linkedinURL: String? = "https://linkedin.com/company/mockpodcast",
        url1: String? = "https://example.com/extra1",
        twitterHandle: String? = "@mockpodcast",
        wechatHandle: String? = nil,
        instagramHandle: String? = "@mockpodcast",
        patreonHandle: String? = "mockpodcast",
        url2: String? = nil,
        facebookHandle: String? = "mockpodcast",
        url3: String? = nil,
        youtubeURL: String? = "https://youtube.com/mockpodcast"
    ) -> ExtraLinksServerData {
        ExtraLinksServerData(
            spotifyURL: spotifyURL,
            amazonMusicURL: amazonMusicURL,
            linkedinURL: linkedinURL,
            url1: url1,
            twitterHandle: twitterHandle,
            wechatHandle: wechatHandle,
            instagramHandle: instagramHandle,
            patreonHandle: patreonHandle,
            url2: url2,
            facebookHandle: facebookHandle,
            url3: url3,
            youtubeURL: youtubeURL
        )
    }
}
