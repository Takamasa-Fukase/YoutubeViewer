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
        print("getPopularVideos")
        let apiKey = ""
        let queries = "?maxResults=20&part=snippet&key=\(apiKey)"
        let url = URL(string: "https://www.googleapis.com/youtube/v3/videos\(queries)")
        guard let url = url else {
            print("urlが不正です")
            return
        }
        let urlRequest = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let jsonData = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        print("jsonData: \(jsonData)")
    }
    
    private func getUserLikedVideos(accessToken: String) async throws {
        print("getUserLikedVideos token: \(accessToken)")
        let apiKey = ""
        let queries = "?myRating=like&maxResults=20&part=snippet&key=\(apiKey)"
        let url = URL(string: "https://www.googleapis.com/youtube/v3/videos\(queries)")
        guard let url = url else {
            print("urlが不正です")
            return
        }
        var urlRequest = URLRequest(url: url)
        // 認証が必要なAPIなのでAuthorizationヘッダーにBearerTokenを設定する
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let jsonData = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        print("jsonData: \(jsonData)")
    }
    
    @objc private func handleSignedInUserChange(notification: Notification) {
        print("HomeVC handleSignedInUserChange notification: \(notification)")
        if let signedInUser = notification.userInfo?["signedInUser"] as? GIDGoogleUser {
            // 認証済みユーザーが高評価した動画一覧を取得
            Task {
                do {
                    try await getUserLikedVideos(accessToken: signedInUser.accessToken.tokenString)
                } catch {
                    print("getVideos error: \(error)")
                }
            }
            
        }else {
            // 認証していないので人気の動画一覧を取得
            Task {
                do {
                    try await getPopularVideos()
                } catch {
                    print("getVideos error: \(error)")
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeVideoListCell.className, for: indexPath) as! HomeVideoListCell
        let url = URL(string: "https://dol.ismcdn.jp/mwimgs/2/7/650/img_2753004f183b1b28893cb3dc0dc4412a263663.jpg")
        cell.thumbnailImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo")
        )
        cell.titleLabel.text = "鉄道で行くスイス】アルプス山脈のふもと超絶景山岳リゾートへの車窓の旅“3つのルート” | 地球の歩き方ニュース＆レポート | ダイヤモンド・オンライン"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SceneDelegate.shared?.showVideoDetailWindow()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
