//
//  HomeViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 27/10/24.
//

import UIKit
import Kingfisher
import GoogleSignIn

class HomeViewController: UIViewController {
    private let videosRepository = VideosRepository()
    var videos: [Video] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        setNaviBarRightButton(systemImageName: "magnifyingglass") {
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSignedInUserChange), name: Notification.Name("signedInUserChanged"), object: nil)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: HomeVideoListCell.className, bundle: nil), forCellReuseIdentifier: HomeVideoListCell.className)
        tableView.contentInset.top = -8
    }
    
    private func getPopularVideos() async throws {
        let videosResponse = try await videosRepository.getPopularVideos()
        videos = videosResponse.items
        tableView.reloadData()
    }
    
    private func getUserLikedVideos(accessToken: String) async throws {
        let videosResponse = try await videosRepository.getUserLikedVideos()
        videos = videosResponse.items
        tableView.reloadData()
    }
    
    @objc private func handleSignedInUserChange(notification: Notification) {
        Task {
            do {
                if let signedInUser = notification.userInfo?["signedInUser"] as? GIDGoogleUser {
                    // 認証済みユーザーが高評価した動画一覧を取得
                    try await getUserLikedVideos(accessToken: signedInUser.accessToken.tokenString)
                    
                } else {
                    // 認証していないので人気の動画一覧を取得
                    try await getPopularVideos()
                }
            } catch {
                print("getVideos error: \(error)")
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeVideoListCell.className, for: indexPath) as! HomeVideoListCell
        let video = videos[indexPath.row]
        let url = URL(string: video.snippet.thumbnails.standard?.url ?? "")
        cell.thumbnailImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo")
        )
        cell.titleLabel.text = video.snippet.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SceneDelegate.shared?.showVideoDetailWindow(video: videos[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
