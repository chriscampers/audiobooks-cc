//
//  PodcastListCellView.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-22.
//

import SwiftUI

struct PodcastListCellView: View {
    let cell: PodcastListCellDto
    
    var body: some View {
        HStack(alignment: .top, spacing: DsSpacing.large) {
            /// One of the images in the mock data is throwing an internal decoding error, it seems to be logged on apple's side rdar://143602439
            /// My understanding is that it is caused by trying to decode a 24bit image when AsyncImage expects 32bit. From the UI there doesn't seem to be any impact.
            /// extractDecodeOptions_block_invoke:1398: ❌ ERROR: kCGImageBlockFormatBGRx8 is called for 24-bpp (8-bpc) image (rdar://143602439)
            AsyncImage(url: URL(string: cell.thumbnail)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .cornerRadius(DsSpacing.medium)
            } placeholder: {
                RoundedRectangle(cornerRadius: DsSpacing.medium)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .shimmering()
                    .overlay {
                        ProgressView()
                    }
            }

            VStack(alignment: .leading, spacing: DsSpacing.small) {
                Text(cell.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(cell.publisher)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .italic()
                    .lineLimit(1)
                if cell.isFavorite {
                    Text("Favorited")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemRed))
                        .lineLimit(1)
                }
            }
            .padding(.vertical, DsSpacing.small)
            
            Spacer()
        }
        .padding(.vertical, DsSpacing.small)
    }
}

struct PodcastListCellSkeletonView: View {
    var body: some View {
        HStack(alignment: .top, spacing: DsSpacing.large) {
            // Thumbnail placeholder
            RoundedRectangle(cornerRadius: DsSpacing.medium)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)
                .shimmering()

            VStack(alignment: .leading, spacing: DsSpacing.medium) {
                // Title line
                RoundedRectangle(cornerRadius: DsSpacing.small)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 180, height: 17)
                    .shimmering()

                // Publisher line
                RoundedRectangle(cornerRadius: DsSpacing.small)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 15)
                    .shimmering()
            }
            .padding(.vertical, DsSpacing.small)
            
            Spacer()
        }
        .padding(.vertical, DsSpacing.small)
    }
}
