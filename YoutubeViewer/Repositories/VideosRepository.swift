//
//  VideosRepository.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 4/11/24.
//

import Foundation
import Alamofire

final class VideosRepository {
    func getPopularVideos() async throws -> VideosResponse {
        let url = URL(string: APIConst.BASE_URL + APIConst.VIDEOS)!
        let request = try URLRequest(url: url, method: .get, headers: APIHeader.applicationJson())
        let parameters: Parameters = [
            "chart": "mostPopular",
            "part": "snippet",
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
    
    func getUserLikedVideos() async throws -> VideosResponse {
        let url = URL(string: APIConst.BASE_URL + APIConst.VIDEOS)!
        let request = try URLRequest(url: url, method: .get, headers: APIHeader.applicationJson())
        let parameters: Parameters = [
            "myRating": "like",
            "part": "snippet",
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
