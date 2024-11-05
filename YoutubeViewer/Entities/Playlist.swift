//
//  Playlist.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 4/11/24.
//

import Foundation

struct PlaylistsResponse: Decodable {
    let items: [Playlist]
}

struct Playlist: Decodable {
    let id: String
    let snippet: Snippet
}
