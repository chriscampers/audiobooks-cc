//
//  ContentView.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear() {
            let vm = PodcastListViewModel(podcastRepository: PodcastApiRepository())
        }
    }
}

#Preview {
    ContentView()
}
