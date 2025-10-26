//
//  PodcastListView.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-22.
//

import SwiftUI

struct PodcastListView: View {
    @StateObject var viewModel: PodcastListViewModel
    
    init(podcastRepository: PodcastRepository,
         favoritesRepository: FavoritePodcastRepository) {
        _viewModel = StateObject(wrappedValue: PodcastListViewModel(podcastRepository: podcastRepository,
                                                                    favoritePodcastRepository: favoritesRepository))
    }

    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .initialLoading:
                    skeletonView
                case .loaded(let cells):
                    podcastListView(cells: cells)
                case.error(_):
                    Text("Error Page")
                }
            }.onAppear {
                Task {
                    await viewModel.onAppear()
                }
            }
            .navigationTitle("Podcasts")
            .alert(item: $viewModel.alertError) { alert in
                switch alert {
                case .noPodcastsLoaded, .issueLoadingNewPage:
                    return Alert(
                        title: Text("Could not load podcasts"),
                        primaryButton: .default(Text("Retry"), action: {
                            Task {
                                await viewModel.loadNextPage()
                            }
                        }),
                        secondaryButton: .cancel()
                    )
                }
            }
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
            NavigationLink(destination: PodcastDetailView(podcast: cells[index],
                                                          favoritesRepository: UserPreferences.shared)) {
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
            .navigationLinkIndicatorVisibility(.hidden)
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
    PodcastListView(podcastRepository: PodcastWebRepository(), favoritesRepository: UserPreferences())
}
