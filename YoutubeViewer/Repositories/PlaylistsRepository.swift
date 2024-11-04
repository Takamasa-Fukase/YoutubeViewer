//
//  PlaylistsRepository.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 4/11/24.
//

import Foundation
import Alamofire

final class PlaylistsRepository {
    func getMyPlaylists() async throws -> PlaylistsResponse {
        let url = URL(string: APIConst.BASE_URL + APIConst.PLAYLISTS)!
        let request = try URLRequest(url: url, method: .get, headers: APIHeader.applicationJson())
        let parameters: Parameters = [
            "mine": "true",
            "part": "snippet,contentDetails,id",
            "maxResults": 20,
            "key": Env.googleApiKey
        ]
        let requestConvertible = try URLEncoding.default.encode(request, with: parameters)
        let result = await AF.request(requestConvertible).serializingDecodable(PlaylistsResponse.self).result
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    func getPlaylistItems(playlistId: String) async throws -> VideosResponse {
        let url = URL(string: APIConst.BASE_URL + APIConst.PLAYLIST_ITEMS)!
        let request = try URLRequest(url: url, method: .get, headers: APIHeader.applicationJson())
        let parameters: Parameters = [
            "mine": "true",
            "part": "snippet,contentDetails",
            "playlistId": playlistId,
            "maxResults": 20,
            "key": Env.googleApiKey
        ]
        let requestConvertible = try URLEncoding.default.encode(request, with: parameters)
        let result = await AF.request(requestConvertible).serializingDecodable(VideosResponse.self).result
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
