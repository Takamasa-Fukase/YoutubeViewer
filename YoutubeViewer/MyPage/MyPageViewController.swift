//
//  MyPageViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 27/10/24.
//

import UIKit
import GoogleSignIn

class MyPageViewController: UIViewController {
    var myChannel: Channel?
    var myPlaylists: [(playlistTitle: String, videos: [Video])] = []
    
    private var signInView: MyPageSignInView!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSignInView()
        setupTableView()
        setNaviBarRightButton(systemImageName: "gearshape") {
            
        }
        setNaviBarRightButton(systemImageName: "magnifyingglass") {
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSignedInUserChange), name: Notification.Name("signedInUserChanged"), object: nil)
        
        // TODO: 後で良い感じにしたい。一旦愚直に実装している
        // 起動時のログイン状態チェック完了時にマイページタブがまだ選択されていない場合はMyPageのloadが終わっていなくてNotificationを受け取れないので、
        // 初回は手動でisSignedInをチェックしてUIをハンドリングする
        handleSignInStatusChange(isSignedIn: SceneDelegate.shared?.signedInUser != nil)
    }
    
    private func setupSignInView() {
        signInView = MyPageSignInView(frame: view.frame)
        signInView.signInButton.addTarget(self, action: #selector(handleSignInButtonTap), for: .touchUpInside)
        view.addSubview(signInView)
        view.addConstraints(for: signInView)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: MyPageProfileCell.className, bundle: nil), forCellReuseIdentifier: MyPageProfileCell.className)
        tableView.register(UINib(nibName: MyPageHorizontalListCell.className, bundle: nil), forCellReuseIdentifier: MyPageHorizontalListCell.className)
    }
    
    @objc private func handleSignInButtonTap() throws {
        Task {
            do {
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: self,
                                                hint: nil,
                                                additionalScopes: ["https://www.googleapis.com/auth/youtube.readonly"])
                let user = result.user
                let accessToken = user.accessToken.tokenString
                print("user: \(user)")
                print("accessToken: \(accessToken)")
                SceneDelegate.shared?.signedInUser = user
                
            } catch {
                print("GoogleSignIn error: \(error)")
            }
        }
    }
    
    private func handleSignInStatusChange(isSignedIn: Bool) {
        print("handleSignInStatusChange isSignedIn: \(isSignedIn)")
        signInView.isHidden = isSignedIn
        tableView.isHidden = !isSignedIn
        if isSignedIn {
            fetch()
        }
    }
    
    @objc private func handleSignedInUserChange(notification: Notification) {
        print("MyPageVC handleSignedInUserChange notification: \(notification)")
        let isSignedIn = notification.userInfo?["signedInUserChanged"] as? GIDGoogleUser != nil
        handleSignInStatusChange(isSignedIn: isSignedIn)
    }
    
    private func fetch() {
        print("fetch")
        Task {
            do {
                async let myChannel = ChannelsRepository().getMyChannels().items.first
                async let myPlaylistInfos = PlaylistsRepository().getMyPlaylists().items
                self.myChannel = try await myChannel
                let playlistInfos = try await myPlaylistInfos
                
                self.myPlaylists = try await withThrowingTaskGroup(of: (playlistTitle: String, videos: [Video]).self) { group in
                    playlistInfos.forEach { playlistInfo in
                        group.addTask {
                            let videos = try await PlaylistsRepository().getPlaylistItems(playlistId: playlistInfo.id).items
                            return (playlistTitle: playlistInfo.snippet.title, videos: videos)
                        }
                    }
                    var playlists: [(playlistTitle: String, videos: [Video])] = []
                    for try await playlist in group {
                        playlists.append(playlist)
                    }
                    return playlists
                }
                tableView.reloadData()
                
            } catch {
                print("MyPage fetch error: \(error)")
            }
        }
    }
}

extension MyPageViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard SceneDelegate.shared?.signedInUser != nil else { return 0 }
        // プロフィールセル用の1（固定） + プレイリストの数（可変）
        return 1 + myPlaylists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageProfileCell.className, for: indexPath) as! MyPageProfileCell
            let url = URL(string: myChannel?.snippet.thumbnails.default?.url ?? "")
            cell.profileIconImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.fill"))
            cell.nameLabel.text = myChannel?.snippet.title
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageHorizontalListCell.className, for: indexPath) as! MyPageHorizontalListCell
            // TODO: indexPath.rowと配列のindexが合致していないと実装ミスを誘発するので、セクション分けた方がいいかも
            let playlist = myPlaylists[indexPath.row - 1]
            cell.titleLabel.text = playlist.playlistTitle
            cell.myPageHorizontalListDelegate = self
            cell.videos = playlist.videos
            return cell
        }
    }
}

extension MyPageViewController: MyPageHorizontalListDelegate {
    func itemSelected(video: Video) {
        SceneDelegate.shared?.showVideoDetailWindow(video: video)
    }
}
