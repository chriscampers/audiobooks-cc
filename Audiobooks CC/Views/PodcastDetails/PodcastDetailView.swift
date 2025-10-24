//
//  PodcastDetailView.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-24.
//

import SwiftUI

typealias PodcastDetailCellDto = PodcastListCellDto

struct PodcastDetailView: View {
    @StateObject private var viewModel: PodcastDetailViewModel
    
    init(podcast: PodcastDetailCellDto,
         favoritesRepository: FavoritePodcastRepository) {
        _viewModel = StateObject(wrappedValue: PodcastDetailViewModel(podcast: podcast,
                                                                      favoriteRepository: UserPreferences.shared))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DsSpacing.large * 2) {
                VStack(spacing: DsSpacing.medium) {
                    Text(viewModel.podcast.title)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    Text(viewModel.podcast.publisher)
                        .font(.headline)
                        .italic()
                        .foregroundColor(.secondary)
                }

                
                AsyncImage(url: URL(string: viewModel.podcast.thumbnail)) { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: DsSpacing.large))
                } placeholder: {
                    RoundedRectangle(cornerRadius: DsSpacing.large)
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: 250)
                        .shimmering()
                }
                
                Button(action: {
                    viewModel.toggleFavorite()
                }) {
                    Text(viewModel.podcast.isFavorite ? "Favorited" : "Favorite")
                        .bold()
                        .padding(DsSpacing.large)
                        .background(Color(.systemRed))
                        .foregroundColor(.white)
                        .cornerRadius(DsSpacing.medium)
                }
                .padding(DsSpacing.medium)
                
                Text(viewModel.podcast.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.bottom, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // PodcastDetailView()
}
