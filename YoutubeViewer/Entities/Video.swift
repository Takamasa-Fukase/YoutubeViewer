//
//  Video.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 3/11/24.
//

import Foundation

struct VideosResponse: Decodable {
    let items: [Video]
}

struct Video: Decodable {
    let videoId: String
    let snippet: Snippet
    
    private enum CodingKeys: String, CodingKey {
        // videosAPIのレスポンスだとこのidが動画IDだが、playlistItemsAPIのレスポンスだとこのidは動画IDではなくプレイリストアイテムIDなので間違えない様に変数名で明示的に区別している
        case videoId = "id"
        case snippet
    }
}

struct Snippet: Decodable {
    let publishedAt: String
    let title: String
    let description: String
    let thumbnails: Thumbnails
}

struct Thumbnails: Decodable {
    let `default`: Thumbnail?
    let medium: Thumbnail?
    let high: Thumbnail?
    let standard: Thumbnail?
    
    struct Thumbnail: Decodable {
        let url: String
    }
}
