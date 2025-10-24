//
//  PodcastListView.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-22.
//

import SwiftUI

struct PodcastListView: View {
    @StateObject var viewModel = PodcastListViewModel(podcastRepository: PodcastApiRepository(),
                                                      favoritePodcastRepository: UserPreferences())
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .initialLoading:
                    skeletonView
                case .loaded(let cells):
                    podcastListView(cells: cells)
                case.error(_):
                    Text("error")
                }
            }.navigationTitle("Podcasts")
        }
    }
    
    private var skeletonView: some View {
        List {
            ForEach(0..<10) { _ in
                PodcastListCellSkeletonView()
            }
        }
        .overlay {
            ProgressView()
        }
    }
    
    private func podcastListView(cells: [PodcastListCellDto]) -> some View {
        List(cells.indices, id: \.self) { index in
            NavigationLink(destination: EmptyView()) {
                VStack {
                    PodcastListCellView(cell: cells[index])
                        .onAppear {
                            Task {
                                await viewModel.cellDidAppear(index: index)
                            }
                        }
                    if viewModel.isPageLoading && index == cells.count - 1 {
                        loadingFooter
                    }
                }
            }
            .listRowSeparator(index == 0 ? .hidden : .visible, edges: .top)
        }
        .listStyle(.plain)
    }
    
    private var loadingFooter: some View {
        VStack {
            Divider()
            PodcastListCellSkeletonView()
                .overlay {
                    ProgressView()
                }
        }
    }
}

#Preview {
    PodcastListView(viewModel: PodcastListViewModel(podcastRepository: MockPodcastRepository(),
                                                    favoritePodcastRepository: UserPreferences()))
}

private class MockPodcastRepository: PodcastRepository {
    func fetchBestPodcasts(page: Int) async throws -> BestPodcastsServerResponse {
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Failed to encode JSON string as Data")
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase // helpful for snake_case keys
            let response = try decoder.decode(BestPodcastsServerResponse.self, from: jsonData)
            return response
        } catch {
            print(error)
        }
        
        return BestPodcastsServerResponse(id: 1, hasNext: true, previousPageNumber: nil, hasPrevious: false, name: "", nextPageNumber: 0, pageNumber: 0, total: 0, listennotesURL: "", podcasts: [], parentID: 0)
    }
    
    let jsonString = """
    {
      "id": 93,
      "name": "Business",
      "total": 807,
      "has_next": true,
      "podcasts": [
        {
          "id": "adbeec8ec43e4957bb63b9f0b7489991",
          "rss": "https://feeds.megaphone.fm/thediaryofaceo",
          "type": "episodic",
          "email": "steven@stevenbartlett.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/7iQXmUT7XGuZSzAMjoNWlX",
            "youtube_url": "https://www.youtube.com/@TheDiaryOfACEO",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "",
            "facebook_handle": "",
            "amazon_music_url": "",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/the-diary-of-a-ceo-with-steven-bartlett-doac-wSgVQrueZOJ-Gflmgre3zuU.800x800.jpg",
          "title": "The Diary Of A CEO with Steven Bartlett",
          "country": "United Kingdom",
          "website": "https://podcasters.spotify.com/pod/show/thediaryofaceo?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            111,
            122,
            67,
            93,
            90
          ],
          "itunes_id": 1291423644,
          "publisher": "DOAC",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/the-diary-of-a-ceo-with-steven-bartlett-doac-vxAF2ZekozI-Gflmgre3zuU.300x300.jpg",
          "is_claimed": false,
          "description": "A few years ago I was a broke, university dropout, at 18 I built an industry leading social media marketing company, and at 27 I resigned as CEO. At 28 I co-founded Flight Story – a marketing and communications company, and thirdweb - a software platform, making it easy to build web3 applications. I then launched private equity fund, Flight Fund, to accelerate the next generation of European unicorns. During this time I decided to launch 'The Diary Of A CEO' podcast with the simple mission of providing an unfiltered journey into the remarkable stories and untold dimensions of the world’s most influential people, experts and thinkers. Thank you for listening.\nMy New Book: https://g2ul0.app.link/DOAC\nIG: https://www.instagram.com/steven\nLI: https://www.linkedin.com/in/stevenbartlett-123",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 74,
          "total_episodes": 551,
          "listennotes_url": "https://www.listennotes.com/c/adbeec8ec43e4957bb63b9f0b7489991/",
          "audio_length_sec": 4025,
          "explicit_content": false,
          "latest_episode_id": "37556abeec3c4ff5ab03ac338e832576",
          "latest_pub_date_ms": 1723784880000,
          "earliest_pub_date_ms": 1506657600503,
          "has_guest_interviews": true,
          "update_frequency_hours": 57,
          "listen_score_global_rank": "0.01%"
        },
        {
          "id": "28ba59be5b8346589e910e24d4b3eed7",
          "rss": "https://pultepodcast.libsyn.com/rss",
          "type": "episodic",
          "email": "Bill@pulte.org",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/31g21O5kSlCstxSswwtPzh",
            "youtube_url": "",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "",
            "facebook_handle": "",
            "amazon_music_url": "",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/the-pulte-podcast-bill-pulte-giving-money-JHeEKxQth0z-xBWa8_-4MTR.1400x1400.jpg",
          "title": "The Pulte Podcast",
          "country": "United States",
          "website": "http://www.pulte.org?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            171,
            93,
            94,
            67
          ],
          "itunes_id": 1525585134,
          "publisher": "Bill Pulte | Giving Money and Knowledge",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/the-pulte-podcast-bill-pulte-giving-money-RGL_ZVvDprm-xBWa8_-4MTR.300x300.jpg",
          "is_claimed": false,
          "description": "I'm giving away money, rent, food, and knowledge to people in need. I've built and sold 8 figure companies and now I want to help people.",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": false,
          "listen_score": 74,
          "total_episodes": 12,
          "listennotes_url": "https://www.listennotes.com/c/28ba59be5b8346589e910e24d4b3eed7/",
          "audio_length_sec": 446,
          "explicit_content": false,
          "latest_episode_id": "e26262d976694428bc1cc8c7af791d1b",
          "latest_pub_date_ms": 1621426832000,
          "earliest_pub_date_ms": 1596040778010,
          "has_guest_interviews": false,
          "update_frequency_hours": 202,
          "listen_score_global_rank": "0.01%"
        },
        {
          "id": "ee84d7d11875465fb89487675ff5425d",
          "rss": "https://feeds.megaphone.fm/WWO2015297742",
          "type": "episodic",
          "email": "wwopodcasts@westwoodone.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/19TdDBlFkqh7uevYO0jFSW",
            "youtube_url": "",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "EdMylett",
            "facebook_handle": "",
            "amazon_music_url": "",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/the-ed-mylett-show-ed-mylett-cumulus-YTuJHXogIjc-PEUIT9RBhZD.1400x1400.jpg",
          "title": "THE ED MYLETT SHOW",
          "country": "United States",
          "website": "https://www.stitcher.com?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            88,
            89,
            90,
            67,
            157,
            171,
            111,
            93,
            181
          ],
          "itunes_id": 1181233130,
          "publisher": "Ed Mylett | Cumulus Podcast Network",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/the-ed-mylett-show-ed-mylett-cumulus-69YnCrZXfos-PEUIT9RBhZD.300x300.jpg",
          "is_claimed": false,
          "description": "The Ed Mylett Show showcases the greatest peak-performers across all industries in one place, sharing their journey, knowledge and thought leadership. With Ed Mylett and featured guests in almost every industry including business, health, collegiate and professional sports, politics, entrepreneurship, science, and entertainment, you'll find motivation, inspiration and practical steps to help you become the best version of you!",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 74,
          "total_episodes": 437,
          "listennotes_url": "https://www.listennotes.com/c/ee84d7d11875465fb89487675ff5425d/",
          "audio_length_sec": 3097,
          "explicit_content": false,
          "latest_episode_id": "093f3e3cf4e946b490bea0f7f07f1e91",
          "latest_pub_date_ms": 1723708800000,
          "earliest_pub_date_ms": 1480363465429,
          "has_guest_interviews": true,
          "update_frequency_hours": 55,
          "listen_score_global_rank": "0.01%"
        },
        {
          "id": "34beae8ad8fd4b299196f413b8270a30",
          "rss": "https://feeds.feedburner.com/WorklifeWithAdamGrant",
          "type": "episodic",
          "email": "podcasts@ted.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/4eylg9GZJOVvUhTynt4jjA",
            "youtube_url": "",
            "linkedin_url": "https://www.linkedin.com/in/adammgrant/",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "AdamMGrant",
            "facebook_handle": "AdamMGrant",
            "amazon_music_url": "",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/worklife-with-adam-grant-ted-KgaXjFPEoVc.1400x1400.jpg",
          "title": "WorkLife with Adam Grant",
          "country": "United States",
          "website": "https://www.ted.com/podcasts/worklife?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            67,
            97,
            111,
            93,
            94
          ],
          "itunes_id": 1346314086,
          "publisher": "TED",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/worklife-with-adam-grant-ted-KgaXjFPEoVc.300x300.jpg",
          "is_claimed": false,
          "description": "\n      <p>You spend a quarter of your life at work. You should enjoy it! Organizational psychologist Adam Grant takes you inside the minds of some of the world’s most unusual professionals to discover the keys to a better work life. From learning how to love your rivals to harnessing the power of frustration, one thing’s for sure: You’ll never see your job the same way again. Produced in partnership with Transmitter Media.</p>\n    ",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": false,
          "listen_score": 74,
          "total_episodes": 178,
          "listennotes_url": "https://www.listennotes.com/c/34beae8ad8fd4b299196f413b8270a30/",
          "audio_length_sec": 2312,
          "explicit_content": false,
          "latest_episode_id": "198e9710e7e943329c023be94075173e",
          "latest_pub_date_ms": 1723557900000,
          "earliest_pub_date_ms": 1518044524170,
          "has_guest_interviews": true,
          "update_frequency_hours": 167,
          "listen_score_global_rank": "0.01%"
        },
        {
          "id": "0d362b13399240de97602ef614acdcbc",
          "rss": "https://feeds.megaphone.fm/startup",
          "type": "episodic",
          "email": "admin@gimletmedia.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/5CnDmMUG0S5bSSw612fs8C",
            "youtube_url": "",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "podcaststartup",
            "facebook_handle": "hearstartup",
            "amazon_music_url": "",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/startup-podcast-gimlet-14zU0c_MOmv-n9PpCBTQvoJ.1400x1400.jpg",
          "title": "StartUp Podcast",
          "country": "United States",
          "website": "https://www.gimletmedia.com/startup?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            97,
            157,
            94,
            68,
            127,
            67,
            171,
            93
          ],
          "itunes_id": 913805339,
          "publisher": "Gimlet",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/startup-podcast-gimlet-8If7QBKU5jb-n9PpCBTQvoJ.300x300.jpg",
          "is_claimed": false,
          "description": "A series about what it's really like to start a business.",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": false,
          "listen_score": 73,
          "total_episodes": 153,
          "listennotes_url": "https://www.listennotes.com/c/0d362b13399240de97602ef614acdcbc/",
          "audio_length_sec": 2176,
          "explicit_content": false,
          "latest_episode_id": "3663e1ba8f944df7956378ab332bf12b",
          "latest_pub_date_ms": 1598004000000,
          "earliest_pub_date_ms": 1396742400151,
          "has_guest_interviews": false,
          "update_frequency_hours": 253,
          "listen_score_global_rank": "0.05%"
        },
        {
          "id": "5f237b79824e4dfb8355f6dff9b1c542",
          "rss": "https://feeds.npr.org/510325/podcast.xml",
          "type": "episodic",
          "email": "podcasts@npr.org",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/4X3yDKgVTWRjSd6r0vhgo4",
            "youtube_url": "",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "planetmoney",
            "facebook_handle": "planetmoney",
            "amazon_music_url": "",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/the-indicator-from-planet-money-npr-ExrCNHIXvAj-G2EDjFO-TLA.1400x1400.jpg",
          "title": "The Indicator from Planet Money",
          "country": "United States",
          "website": "https://www.npr.org/podcasts/510325/the-indicator-from-planet-money?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            99,
            98,
            144,
            171,
            67,
            93
          ],
          "itunes_id": 1320118593,
          "publisher": "NPR",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/the-indicator-from-planet-money-npr-GlBq-bOfiw6-G2EDjFO-TLA.300x300.jpg",
          "is_claimed": false,
          "description": "A little show about big ideas. From the people who make <em>Planet Money</em>, <em>The Indicator</em> helps you make sense of what's happening today. It's a quick hit of insight into work, business, the economy, and everything else. Listen weekday afternoons.<br><br><em>Try Planet Money+! a new way to support the show you love, get a sponsor-free feed of the podcast, *and* get access to bonus content. You'll also get access to The Indicator and Planet Money Summer School, both without interruptions. sign up at plus.npr.org/planetmoney</em>",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 73,
          "total_episodes": 1567,
          "listennotes_url": "https://www.listennotes.com/c/5f237b79824e4dfb8355f6dff9b1c542/",
          "audio_length_sec": 568,
          "explicit_content": false,
          "latest_episode_id": "4c86828f37464d7bb47585b349ae58ea",
          "latest_pub_date_ms": 1723759424000,
          "earliest_pub_date_ms": 1527108300299,
          "has_guest_interviews": false,
          "update_frequency_hours": 29,
          "listen_score_global_rank": "0.01%"
        },
        {
          "id": "2184bada602d431689dbb4c6c1bc5839",
          "rss": "https://feeds.simplecast.com/atgtihd0",
          "type": "episodic",
          "email": "interactive@life.church",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/7tznexFwtbxfPOYF5mxkxI",
            "youtube_url": "https://www.youtube.com/@craiggroeschel",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "craiggroeschel",
            "facebook_handle": "life.church",
            "amazon_music_url": "",
            "instagram_handle": "craiggroeschel"
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/craig-groeschel-leadership-podcast-lifechurch--_K8zgsM0x1-dy-uJsHC_9T.1400x1400.jpg",
          "title": "Craig Groeschel Leadership Podcast",
          "country": "United States",
          "website": "https://www.life.church/leadershippodcast?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            93,
            97
          ],
          "itunes_id": 1070649025,
          "publisher": "Life.Church",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/craig-groeschel-leadership-podcast-lifechurch-OU5cY0mgjsb-dy-uJsHC_9T.300x300.jpg",
          "is_claimed": false,
          "description": "The Craig Groeschel Leadership Podcast offers personal, practical coaching lessons that take the mystery out of leadership. In each episode of the Craig Groeschel Leadership Podcast, Craig brings you empowering insights and easy-to-understand takeaways you can use to lead yourself and lead your team. You’ll learn effective ways to grow as a leader, optimize your time, develop your team, and structure your organization.",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 72,
          "total_episodes": 159,
          "listennotes_url": "https://www.listennotes.com/c/2184bada602d431689dbb4c6c1bc5839/",
          "audio_length_sec": 1873,
          "explicit_content": false,
          "latest_episode_id": "01bc207ab5e94f7192d9e624fd9af9d1",
          "latest_pub_date_ms": 1722495600000,
          "earliest_pub_date_ms": 1452675180156,
          "has_guest_interviews": true,
          "update_frequency_hours": 357,
          "listen_score_global_rank": "0.05%"
        },
        {
          "id": "fc6d33e22b7f4db38df3bb64a9a8c227",
          "rss": "https://tonyrobbins.libsyn.com/rss",
          "type": "episodic",
          "email": "tonyrobbins.social@gmail.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/6fZXOzehJ9JtOyFjirF3qt",
            "youtube_url": "",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "tonyrobbins",
            "facebook_handle": "TonyRobbins",
            "amazon_music_url": "",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/the-tony-robbins-podcast-tony-robbins-PEpKfIaRX7J-eh9wNFJcP1W.1400x1400.jpg",
          "title": "The Tony Robbins Podcast",
          "country": "United States",
          "website": "http://tonyrobbins.com/podcast?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            67,
            97,
            111,
            144,
            181,
            93,
            78,
            157,
            90
          ],
          "itunes_id": 1098413063,
          "publisher": "Tony Robbins",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/the-tony-robbins-podcast-tony-robbins-fCN5Iu9zA-0-eh9wNFJcP1W.300x300.jpg",
          "is_claimed": false,
          "description": "“Why live an ordinary life, when you can live an extraordinary one?” Tony Robbins, the #1 Life and Business Strategist, has helped over 50 million people from 100 countries create real and lasting change in their lives. In this podcast, he shares proven strategies and tactics so you, too, can achieve massive results in your business, relationships, health and finances. In addition to excerpts from his signature events and other exclusive, never-before-released audio content, Tony and his team also conduct deeply insightful interviews with the most prominent masterminds and experts on the global stage.",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 72,
          "total_episodes": 173,
          "listennotes_url": "https://www.listennotes.com/c/fc6d33e22b7f4db38df3bb64a9a8c227/",
          "audio_length_sec": 2920,
          "explicit_content": false,
          "latest_episode_id": "8a767a2dbfd2436c8a46cd13e73c911f",
          "latest_pub_date_ms": 1721877960000,
          "earliest_pub_date_ms": 1459373820099,
          "has_guest_interviews": true,
          "update_frequency_hours": 739,
          "listen_score_global_rank": "0.05%"
        },
        {
          "id": "ed79b615ed074204bc4702b56a264a78",
          "rss": "https://app.kajabi.com/podcasts/2147806218/feed",
          "type": "episodic",
          "email": "brooke@thelifecoachschool.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "",
            "youtube_url": "",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "brookecastillo",
            "facebook_handle": "",
            "amazon_music_url": "",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/the-life-coach-school-podcast-brooke-castillo-yfcBwN92Wdj-V5of7JlG_RD.1400x1400.jpg",
          "title": "The Life Coach School Podcast",
          "country": "United States",
          "website": "https://www.thelifecoachschool.com/podcasts/the-life-coach-school-podcast-2?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            67,
            88,
            90,
            93,
            94,
            111,
            115
          ],
          "itunes_id": 870239631,
          "publisher": "Brooke Castillo",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/the-life-coach-school-podcast-brooke-castillo-C-zYxJ2e_TW-V5of7JlG_RD.300x300.jpg",
          "is_claimed": false,
          "description": "\n      The Life Coach School Podcast is your go-to resource for learning, growing, and becoming certified as a Life Coach & Weight Loss Coach. Through this podcast, you'll hear directly from the Master Coach Brooke Castillo to help you better understand life coaching, the required skills and mindsets, and how we focus on serving the client to get them the results they seek.  At The Life Coach School, we offer a thorough and intense certification course that produces some of the most successful coaches coaching today. Learn more at TheLifeCoachSchool.com.\n    ",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 72,
          "total_episodes": 537,
          "listennotes_url": "https://www.listennotes.com/c/ed79b615ed074204bc4702b56a264a78/",
          "audio_length_sec": 1882,
          "explicit_content": false,
          "latest_episode_id": "ce697e81f08242ccbe45be17b08e55ce",
          "latest_pub_date_ms": 1722502800000,
          "earliest_pub_date_ms": 1398606925536,
          "has_guest_interviews": false,
          "update_frequency_hours": 302,
          "listen_score_global_rank": "0.05%"
        },
        {
          "id": "bee3a6eeb43d45d482cff16d7e6eec6d",
          "rss": "https://mcsorleys.barstoolsports.com/feed/bffs",
          "type": "episodic",
          "email": "podcasting@barstoolsports.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "",
            "youtube_url": "",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "",
            "facebook_handle": "",
            "amazon_music_url": "",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/bffs-with-dave-portnoy-josh-richards-and-c-YmGvaLCjt-UwCtO6PxIiq.1400x1400.jpg",
          "title": "BFFs with Dave Portnoy, Josh Richards, and Brianna Chickenfry",
          "country": "United States",
          "website": "https://www.barstoolsports.com/shows/134/Bffs?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            93,
            98,
            67
          ],
          "itunes_id": 1534324153,
          "publisher": "Barstool Sports",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/bffs-with-dave-portnoy-josh-richards-and-0vXYw5UR7ut-UwCtO6PxIiq.300x300.jpg",
          "is_claimed": false,
          "description": "<p>The unlikely trio of Josh Richards, Dave Portnoy & Brianna Chickenfry team up to talk all things pop culture, celebrities, influencers & TikTok. You never know what to expect from this trio from breaking entertainment news to generational differences they’re sure to make you laugh while keeping you up to date.</p><br /><p>You can find every episode of this show on Apple Podcasts, Spotify or YouTube. Prime Members can listen ad-free on Amazon Music. For more, visit <a href=\"https://barstool.link/bffspod\">barstool.link/bffspod</a></p>",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 71,
          "total_episodes": 188,
          "listennotes_url": "https://www.listennotes.com/c/bee3a6eeb43d45d482cff16d7e6eec6d/",
          "audio_length_sec": 3680,
          "explicit_content": true,
          "latest_episode_id": "9787bbfd98a0499dab084a2e2cff3f80",
          "latest_pub_date_ms": 1723680000000,
          "earliest_pub_date_ms": 1601668154000,
          "has_guest_interviews": true,
          "update_frequency_hours": 168,
          "listen_score_global_rank": "0.05%"
        },
        {
          "id": "13a7957aeac34e1c9e004f2a2ced5fb0",
          "rss": "https://feeds.megaphone.fm/pivot",
          "type": "episodic",
          "email": "pivot@voxmedia.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/4MU3RFGELZxPT9XHVwTNPR",
            "youtube_url": "",
            "linkedin_url": "https://www.linkedin.com/company/re-code-news/",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "recode",
            "facebook_handle": "RecodeDotNet",
            "amazon_music_url": "",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/pivot-new-york-magazine-b0XsOSV7WDZ-YyJxq4Dbk67.1400x1400.jpg",
          "title": "Pivot",
          "country": "United States",
          "website": "http://nymag.com/pivot?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            99,
            97,
            157,
            94,
            67,
            171,
            131,
            127,
            93
          ],
          "itunes_id": 1073226719,
          "publisher": "New York Magazine",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/pivot-new-york-magazine-L2FeZNEqKst-YyJxq4Dbk67.300x300.jpg",
          "is_claimed": false,
          "description": "Every Tuesday and Friday, tech journalist Kara Swisher and NYU Professor Scott Galloway offer sharp, unfiltered insights into the biggest stories in tech, business, and politics. They make bold predictions, pick winners and losers, and bicker and banter like no one else. After all, with great power comes great scrutiny. From New York Magazine and the Vox Media Podcast Network.",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 71,
          "total_episodes": 584,
          "listennotes_url": "https://www.listennotes.com/c/13a7957aeac34e1c9e004f2a2ced5fb0/",
          "audio_length_sec": 3443,
          "explicit_content": false,
          "latest_episode_id": "16ed5767cdab4f73916a00335b9d7ff2",
          "latest_pub_date_ms": 1723802400000,
          "earliest_pub_date_ms": 1537812480581,
          "has_guest_interviews": true,
          "update_frequency_hours": 83,
          "listen_score_global_rank": "0.05%"
        },
        {
          "id": "c5ce6c02cbf1486496206829f7d42e8e",
          "rss": "https://rss.art19.com/the-best-one-yet",
          "type": "episodic",
          "email": "iwonder@wondery.com",
          "extra": {
            "url1": "http://www.marketsnacks.com/",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/5RllMBgvDnTau8nnsCUdse",
            "youtube_url": "",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "marketsnacks",
            "facebook_handle": "MarketSnacks",
            "amazon_music_url": "",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/the-best-one-yet-nick-jack-studios-EgFpILavQ3b-kmx0XIZTAys.1400x1400.jpg",
          "title": "The Best One Yet",
          "country": "United States",
          "website": "https://wondery.com/shows/the-best-one-yet/?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            67,
            93,
            95,
            99,
            98
          ],
          "itunes_id": 1386234384,
          "publisher": "Nick & Jack Studios",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/the-best-one-yet-nick-jack-studios-At9FH6iux5Q-kmx0XIZTAys.300x300.jpg",
          "is_claimed": false,
          "description": "\n      <p>Feel brighter every day with our 20-minute pop-biz news podcast. The 3 business stories you need, with fresh takes you can pretend you came up with — Pairs perfectly with your morning oatmeal ritual. Hosted by Jack Crivici-Kramer & Nick Martell. Formerly known as “Snacks Daily”, Nick and Jack continue their podcast independent from Robinhood.</p>\n    ",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 71,
          "total_episodes": 1264,
          "listennotes_url": "https://www.listennotes.com/c/c5ce6c02cbf1486496206829f7d42e8e/",
          "audio_length_sec": 1146,
          "explicit_content": false,
          "latest_episode_id": "22b5bfb071564b78b42e3cb29cf38be0",
          "latest_pub_date_ms": 1723446060000,
          "earliest_pub_date_ms": 1553519101215,
          "has_guest_interviews": false,
          "update_frequency_hours": 33,
          "listen_score_global_rank": "0.05%"
        },
        {
          "id": "d863da7f921e435fb35f512b54e774d6",
          "rss": "https://rss.art19.com/masters-of-scale",
          "type": "episodic",
          "email": "hello@mastersofscale.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/1bJRgaFZHuzifad4IAApFR",
            "youtube_url": "",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "mastersofscale",
            "facebook_handle": "mastersofscale",
            "amazon_music_url": "",
            "instagram_handle": "mastersofscale"
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/masters-of-scale-waitwhat-w5Tb9hPCs-8-mYoV0CUyxTD.1400x1400.jpg",
          "title": "Masters of Scale",
          "country": "United States",
          "website": "http://www.mastersofscale.com?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            122,
            97,
            93,
            149,
            127,
            157,
            67,
            171,
            173
          ],
          "itunes_id": 1227971746,
          "publisher": "WaitWhat ",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/masters-of-scale-waitwhat-pC8IU6xO9LK-mYoV0CUyxTD.300x300.jpg",
          "is_claimed": false,
          "description": "\n      <p>On Masters of Scale, iconic business leaders share lessons and strategies that have helped them grow the world's most fascinating companies. Founders, CEOs, and dynamic innovators join candid conversations about their triumphs and challenges with a set of luminary hosts, including founding host Reid Hoffman (LinkedIn co-founder and Greylock partner). From navigating early prototypes to expanding brands globally, Masters of Scale provides priceless insights to help anyone grow their dream enterprise.</p>\n    ",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": false,
          "listen_score": 71,
          "total_episodes": 493,
          "listennotes_url": "https://www.listennotes.com/c/d863da7f921e435fb35f512b54e774d6/",
          "audio_length_sec": 2002,
          "explicit_content": false,
          "latest_episode_id": "dcf9305c40eb43d8b2bf0b61f8dd4f79",
          "latest_pub_date_ms": 1723712400000,
          "earliest_pub_date_ms": 1492543297488,
          "has_guest_interviews": true,
          "update_frequency_hours": 69,
          "listen_score_global_rank": "0.05%"
        },
        {
          "id": "5590cb1318054bceb942564a4f067eb6",
          "rss": "https://www.marketplace.org/feed/podcast/marketplace",
          "type": "episodic",
          "email": "marketplacecomments@marketplace.org",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/6zYlX5UGEPmNCWacYUJQGD",
            "youtube_url": "",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "Marketplace",
            "facebook_handle": "marketplaceapm",
            "amazon_music_url": "",
            "instagram_handle": "marketplaceapm"
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/marketplace-marketplace-WHc17NQy23S-Jing2WtK5UE.1400x1400.jpg",
          "title": "Marketplace",
          "country": "United States",
          "website": "https://www.marketplace.org/shows/marketplace/?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            95,
            99,
            173,
            93,
            67
          ],
          "itunes_id": 201853034,
          "publisher": "Marketplace",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/marketplace-marketplace-_YVywHeR0-S-Jing2WtK5UE.300x300.jpg",
          "is_claimed": false,
          "description": "<p>Every weekday, host Kai Ryssdal helps you make sense of the day’s business and economic news — no econ degree or finance background required. “Marketplace” takes you beyond the numbers, bringing you context. Our team of reporters all over the world speak with CEOs, policymakers and regular people just trying to get by.</p>\n",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 71,
          "total_episodes": 576,
          "listennotes_url": "https://www.listennotes.com/c/5590cb1318054bceb942564a4f067eb6/",
          "audio_length_sec": 1655,
          "explicit_content": false,
          "latest_episode_id": "36fc5370f5524aceb53e2a9bdc948245",
          "latest_pub_date_ms": 1723763666000,
          "earliest_pub_date_ms": 1640304971049,
          "has_guest_interviews": true,
          "update_frequency_hours": 28,
          "listen_score_global_rank": "0.05%"
        },
        {
          "id": "40b72ce8610649529542575dedf06c86",
          "rss": "https://allinchamathjason.libsyn.com/rss",
          "type": "episodic",
          "email": "theallinpod@gmail.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/2IqXAVFR4e0Bmyjsdc8QzF",
            "youtube_url": "https://www.youtube.com/channel/UCESLZhusAkFfsNsApnjF_Cg",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "theallinpod",
            "facebook_handle": "",
            "amazon_music_url": "https://music.amazon.com/podcasts/79ad0c9b-27fa-461f-b72f-2d0979d4a849/all-in-with-chamath-jason-sacks-friedberg",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/all-in-with-chamath-jason-sacks-friedberg-pQG1B_c0qbk-0eWaLuirNTJ.1400x1400.jpg",
          "title": "All-In with Chamath, Jason, Sacks & Friedberg",
          "country": "United States",
          "website": "http://allinchamathjason.libsyn.com/website?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            67,
            127,
            93,
            171,
            98
          ],
          "itunes_id": 1502871393,
          "publisher": "All-In Podcast, LLC",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/all-in-with-chamath-jason-sacks-friedberg-PbT-1XEWOoz-0eWaLuirNTJ.300x300.jpg",
          "is_claimed": false,
          "description": "Industry veterans, degenerate gamblers & besties Chamath Palihapitiya, Jason Calacanis, David Sacks & David Friedberg cover all things economic, tech, political, social & poker.",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 70,
          "total_episodes": 207,
          "listennotes_url": "https://www.listennotes.com/c/40b72ce8610649529542575dedf06c86/",
          "audio_length_sec": 5170,
          "explicit_content": true,
          "latest_episode_id": "ba7f5c2d77534edab0aafb2499127f97",
          "latest_pub_date_ms": 1723833720000,
          "earliest_pub_date_ms": 1584237849193,
          "has_guest_interviews": false,
          "update_frequency_hours": 159,
          "listen_score_global_rank": "0.05%"
        },
        {
          "id": "23bd4f3432c2452d93f525e2446a5878",
          "rss": "https://feeds.simplecast.com/4YELvXgu",
          "type": "episodic",
          "email": "rss@earwolf.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/0Vdp4gyQoY0kkcvaLnIgvx",
            "youtube_url": "",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "",
            "facebook_handle": "",
            "amazon_music_url": "",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/scam-goddess-earwolf-laci-mosley-pMX-87Jicaq-PstEMgqXCUd.1400x1400.jpg",
          "title": "Scam Goddess",
          "country": "United States",
          "website": "https://teamcoco.com/?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            93,
            133,
            67,
            135
          ],
          "itunes_id": 1479455008,
          "publisher": "Earwolf & Laci Mosley",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/scam-goddess-earwolf-laci-mosley-fy8Bs4RlT06-PstEMgqXCUd.300x300.jpg",
          "is_claimed": false,
          "description": "“Scam Goddess is a podcast dedicated to fraud and all those who practice it! Each week host Laci Mosley (aka Scam Goddess) keeps listeners up to date on current rackets, digs deep into the latest scams, and breaks down historic hoodwinks alongside some of your favorite comedians! It's like true crime only without all the death! True fun crime!”",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 70,
          "total_episodes": 239,
          "listennotes_url": "https://www.listennotes.com/c/23bd4f3432c2452d93f525e2446a5878/",
          "audio_length_sec": 4158,
          "explicit_content": true,
          "latest_episode_id": "a505d2c2dde74ae9ab2b7a1dd0b61eae",
          "latest_pub_date_ms": 1723781100000,
          "earliest_pub_date_ms": 1420099200036,
          "has_guest_interviews": true,
          "update_frequency_hours": 83,
          "listen_score_global_rank": "0.05%"
        },
        {
          "id": "c73271d55ffa4e2d9b529220072fbd79",
          "rss": "https://www.omnycontent.com/d/playlist/e73c998e-6e60-432f-8610-ae210140c5b1/3e7f11c6-1170-40a0-be58-ae330037e2f5/dea7cb4c-cbee-49ce-83f0-ae330037e303/podcast.rss",
          "type": "episodic",
          "email": "michael@earnyourleisure.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/2S4tSSlT71Z5i8Dt1vlDJc",
            "youtube_url": "",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "",
            "facebook_handle": "",
            "amazon_music_url": "",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/earn-your-leisure-eyl-network--AFWvtrYomD-CSRy4Lz625Y.1400x1400.jpg",
          "title": "Earn Your Leisure",
          "country": "United States",
          "website": "https://redcircle.com/shows/earn-your-leisure7962?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            67,
            93,
            181
          ],
          "itunes_id": 1450211392,
          "publisher": "EYL Network",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/earn-your-leisure-eyl-network-Ni5dRWAQFJc-CSRy4Lz625Y.300x300.jpg",
          "is_claimed": false,
          "description": "<p>Welcome to The Earn Your Leisure Podcast. Rashad Bilal and Troy Millings will be your host. Earn Your Leisure will be giving you behind the scenes financial views into the entertainment and sports industries as well as highlighting back stories of entrepreneurs. We will also be breaking down business models and examining the latest trends in finance. Earn Your Leisure is a college business class mixed with pop culture. We blend the two together for a unique and exciting look into the world of business. Let’s go!! #earnyourleisurepodcast</p>",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 70,
          "total_episodes": 1078,
          "listennotes_url": "https://www.listennotes.com/c/c73271d55ffa4e2d9b529220072fbd79/",
          "audio_length_sec": 1919,
          "explicit_content": false,
          "latest_episode_id": "8c25ea3b7a754407ad6fc01437798ac7",
          "latest_pub_date_ms": 1723813200000,
          "earliest_pub_date_ms": 1548186121023,
          "has_guest_interviews": true,
          "update_frequency_hours": 24,
          "listen_score_global_rank": "0.05%"
        },
        {
          "id": "fbecfdd4116e4e7a954bd6bc4cb0b406",
          "rss": "https://feeds.megaphone.fm/YAP3268529120",
          "type": "episodic",
          "email": "podcast@amyporterfield.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/5z7TqC6tll8egI9prMqXhd",
            "youtube_url": "",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "AmyPorterfield",
            "facebook_handle": "AmyPorterfield",
            "amazon_music_url": "",
            "instagram_handle": "amyporterfield"
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/online-marketing-made-easy-with-amy-oE5S3uhKaP1-jXUyf4vBV20.1400x1400.jpg",
          "title": "Online Marketing Made Easy with Amy Porterfield",
          "country": "United States",
          "website": "https://amyporterfield.com/category/podcast/?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            67,
            97,
            94,
            157,
            93,
            173
          ],
          "itunes_id": 594703545,
          "publisher": "Amy Porterfield",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/online-marketing-made-easy-with-amy-8ng4N5qbGE9-jXUyf4vBV20.300x300.jpg",
          "is_claimed": false,
          "description": "Ever wish you had a business mentor with over a decade of experience whispering success secrets in your ear? That’s exactly what you’ll get when you tune into the top-ranked Online Marketing Made Easy Podcast with your host, 9 to 5er turned CEO of a multi-million dollar business & NY Times Best Selling Author, Amy Porterfield. Her specialty? Breaking down big ideas and strategies into actionable step-by-step processes designed to get you results with a whole lot less stress. Tune in, get inspired, and get ready to discover why hundreds of thousands of online business owners turn to Amy for guidance when it comes to all things online business including digital courses, list building, social media, content, webinars, and so much more. Whether you're a budding entrepreneur, have a comfy side-hustle, or are looking to take your business to the next level, each episode is designed to help you take immediate action on the most important strategies for starting and growing your online business today.",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 70,
          "total_episodes": 754,
          "listennotes_url": "https://www.listennotes.com/c/fbecfdd4116e4e7a954bd6bc4cb0b406/",
          "audio_length_sec": 2290,
          "explicit_content": false,
          "latest_episode_id": "5aebf79cc8e44ef3ba1116dae3596155",
          "latest_pub_date_ms": 1723698060000,
          "earliest_pub_date_ms": 1358200860744,
          "has_guest_interviews": true,
          "update_frequency_hours": 83,
          "listen_score_global_rank": "0.05%"
        },
        {
          "id": "8f0714068478481192cf9553881463d9",
          "rss": "https://rss.acast.com/theeconomistallaudio",
          "type": "episodic",
          "email": "podcasts@economist.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/2ZFDmgDS2Z6xccP51s1zFQ",
            "youtube_url": "https://www.youtube.com/user/economistmagazine",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "TheEconomist",
            "facebook_handle": "TheEconomist",
            "amazon_music_url": "",
            "instagram_handle": "theeconomist"
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/economist-podcasts-the-economist-aLxSD3lKrY5-uZJQ8Padqyg.1400x1400.jpg",
          "title": "Economist Podcasts",
          "country": "United States",
          "website": "https://play.acast.com/s/theeconomistmoneytalks/money-talks-three-economies?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            67,
            99,
            98,
            93
          ],
          "itunes_id": 151230264,
          "publisher": "The Economist",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/economist-podcasts-the-economist-iwN-8FXu1Qq-uZJQ8Padqyg.300x300.jpg",
          "is_claimed": false,
          "description": "<p><span style=\"font-family: monospace; font-size: medium; white-space: pre;\">Every weekday our global network of correspondents makes sense of the stories beneath the headlines. We bring you surprising trends and tales from around the world, current affairs, business and finance — as well as science and technology.</span></p><p> </p><br /><hr><p style='color:grey; font-size:0.75em;'> Hosted on Acast. See <a style='color:grey;' target='_blank' rel='noopener noreferrer' href='https://acast.com/privacy'>acast.com/privacy</a> for more information.</p>",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 70,
          "total_episodes": 1506,
          "listennotes_url": "https://www.listennotes.com/c/8f0714068478481192cf9553881463d9/",
          "audio_length_sec": 1421,
          "explicit_content": false,
          "latest_episode_id": "b618f36172684f5f8e1607110d084633",
          "latest_pub_date_ms": 1723800981000,
          "earliest_pub_date_ms": 1430798497479,
          "has_guest_interviews": true,
          "update_frequency_hours": 28,
          "listen_score_global_rank": "0.05%"
        },
        {
          "id": "d1336f3217eb4510bdbcdf021a38de38",
          "rss": "https://feeds.megaphone.fm/ADL1740142880",
          "type": "episodic",
          "email": "podcasts@qcodemedia.com",
          "extra": {
            "url1": "",
            "url2": "",
            "url3": "",
            "spotify_url": "https://open.spotify.com/show/7DFQyVP0hc3d1xnht1U3UI",
            "youtube_url": "",
            "linkedin_url": "",
            "wechat_handle": "",
            "patreon_handle": "",
            "twitter_handle": "",
            "facebook_handle": "",
            "amazon_music_url": "",
            "instagram_handle": ""
          },
          "image": "https://cdn-images-3.listennotes.com/podcasts/abundant-ever-after-with-cathy-heller-cathy-n36tdkGlLQW-W-XR2oujCdK.1400x1400.jpg",
          "title": "Abundant Ever After with Cathy Heller",
          "country": "United States",
          "website": "https://www.cathyheller.com/?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
          "language": "English",
          "genre_ids": [
            100,
            88,
            90,
            94,
            132,
            69,
            244,
            122,
            67,
            70,
            171,
            93
          ],
          "itunes_id": 1191831035,
          "publisher": "Cathy Heller",
          "thumbnail": "https://cdn-images-3.listennotes.com/podcasts/abundant-ever-after-with-cathy-heller-cathy-V-FgUiC32Oj-W-XR2oujCdK.300x300.jpg",
          "is_claimed": false,
          "description": "Life is too short to be building someone else's dream. On Abundant Ever After, top ranking podcast host, business and spiritual coach, and bestselling author Cathy Heller gives you the tools to change your frequency, allow in new possibilities, and become the director of your life. You'll learn how to get unstuck from your fears and self doubt, find your confidence, change your subconscious program, shift your mindset, and build an abundant dream life where you can make an impact and get paid to be authentically you. \n\nThis show features coaching calls and heart-to-heart conversations with successful authors, celebrities, entrepreneurs, spiritual leaders, experts, and everyday heroes about what led them to the biggest moments in their lives, and how you too can create a new reality that you can't wait to wake up to every single day. \n\nYou've got so much to contribute and Cathy is here to help you do it. \n\nFollow Cathy @cathy.heller on Instagram for daily sparks of inspiration. \nSubscribe to Abundant Ever After and share the show with someone who needs to hear it.",
          "looking_for": {
            "guests": false,
            "cohosts": false,
            "sponsors": false,
            "cross_promotion": false
          },
          "has_sponsors": true,
          "listen_score": 70,
          "total_episodes": 892,
          "listennotes_url": "https://www.listennotes.com/c/d1336f3217eb4510bdbcdf021a38de38/",
          "audio_length_sec": 2973,
          "explicit_content": false,
          "latest_episode_id": "1cbb8e1cf0d44389ab6d0c4e4fe457bd",
          "latest_pub_date_ms": 1723446000000,
          "earliest_pub_date_ms": 1483455806890,
          "has_guest_interviews": true,
          "update_frequency_hours": 167,
          "listen_score_global_rank": "0.05%"
        }
      ],
      "parent_id": 67,
      "page_number": 2,
      "has_previous": true,
      "listennotes_url": "https://www.listennotes.com/best-business-podcasts-93/",
      "next_page_number": 3,
      "previous_page_number": 1
    }
    """
}
