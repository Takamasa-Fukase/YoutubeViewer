//
//  PlaylistVideo.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

struct PlaylistVideosResponse: Decodable {
    let items: [PlaylistVideo]
}

struct PlaylistVideo: Decodable {
    let playlistItemId: String
    let snippet: Snippet
    let contentDetails: ContentDetails
    
    private enum CodingKeys: String, CodingKey {
        // videosAPIのレスポンスだとこのidが動画IDだが、playlistItemsAPIのレスポンスだとこのidは動画IDではなくプレイリストアイテムIDなので間違えない様に変数名で明示的に区別している
        case playlistItemId = "id"
        case snippet
        case contentDetails
    }
    
    struct ContentDetails: Decodable {
        let videoId: String
    }
}

extension PlaylistVideo {
    var convertedToVideo: Video {
        return .init(videoId: self.contentDetails.videoId,
                     snippet: self.snippet)
    }
}
