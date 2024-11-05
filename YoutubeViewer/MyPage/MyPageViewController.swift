//
//  MyPageViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 27/10/24.
//

import UIKit
import GoogleSignIn
import KeychainAccess

class MyPageViewController: UIViewController {    
    var profileModel: ProfileModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var playlistModels: [PlaylistModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var signInView: MyPageSignInView!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSignInView()
        setupTableView()
        // 初回load時は手動でisSignedInをチェックしてUIの表示切り替えを行っている
        // 起動時のログイン状態復元結果が返ってきた時点でマイページタブがまだ選択されていない場合はMyPageのloadが終わっていなくてNotificationを受け取れない為
        handleSignInStatusChange()
        setNaviBarRightButton(systemImageName: "gearshape") {
            
        }
        setNaviBarRightButton(systemImageName: "magnifyingglass") {
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSignInStatusChange), name: NotificationKey.signInStatusChanged, object: nil)
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
                print("ログイン成功 accessToken: \(accessToken)")
                Keychain()[KeychainKey.GOOGLE_AUTH_ACCESS_TOKEN] = accessToken
                AppState.shared.isSignedIn = true
                
            } catch {
                print("GoogleSignIn error: \(error)")
            }
        }
    }
    
    @objc private func handleSignInStatusChange() {
        signInView.isHidden = AppState.shared.isSignedIn
        tableView.isHidden = !AppState.shared.isSignedIn
        if AppState.shared.isSignedIn {
            fetch()
        }
    }
    
    @MainActor private func showChannelAndReload(_ channel: Channel?) {
        profileModel = .init(
            thumbnailUrl: channel?.snippet.thumbnails.default?.url ?? "",
            title: channel?.snippet.title ?? ""
        )
    }
    
    @MainActor private func showPlaylistsAndReload(_ playlists: [Playlist]) {
        playlistModels = playlists.map({ playlists in
            return .init(
                id: playlists.id,
                title: playlists.snippet.title,
                videos: []
            )
        })
    }
        
    private func getPlaylistItemsAndReload() async throws {
        _ = try await withThrowingTaskGroup(of: Void.self) { group in
            self.playlistModels.enumerated().forEach({ (index, playlistModel) in
                group.addTask {
                    let videos = try await PlaylistsRepository().getPlaylistItems(playlistId: playlistModel.id).items
                    return await self.showPlaylistItemsAndReload(index: index, videos: videos)
                }
            })
            // エラーを呼び出し元に渡すためにtryする
            for try await _ in group {}
        }
    }
    
    @MainActor private func showPlaylistItemsAndReload(index: Int, videos: [PlaylistVideo]) {
        playlistModels[index].videos = videos
    }
    
    private func fetch() {
        Task {
            do {
                _ = try await withThrowingTaskGroup(of: Void.self) { group in
                    group.addTask {
                        let channel = try await ChannelsRepository().getMyChannels().items.first
                        await self.showChannelAndReload(channel)
                    }
                    group.addTask {
                        let playlists = try await PlaylistsRepository().getMyPlaylists().items
                        await self.showPlaylistsAndReload(playlists)
                        try await self.getPlaylistItemsAndReload()
                    }
                    // エラーを呼び出し元に渡すためにtryする
                    for try await _ in group {}
                }
                
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
        guard AppState.shared.isSignedIn else { return 0 }
        // プロフィールセル用の1（固定） + プレイリストの数（可変）
        return 1 + playlistModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageProfileCell.className, for: indexPath) as! MyPageProfileCell
            let url = URL(string: profileModel?.thumbnailUrl ?? "")
            cell.profileIconImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.fill"))
            cell.nameLabel.text = profileModel?.title ?? ""
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageHorizontalListCell.className, for: indexPath) as! MyPageHorizontalListCell
            let playlistModel = playlistModels[indexPath.row - 1]
            cell.titleLabel.text = playlistModel.title
            cell.myPageHorizontalListDelegate = self
            cell.videos = playlistModel.videos
            cell.collectionView.reloadData()
            return cell
        }
    }
}

extension MyPageViewController: MyPageHorizontalListDelegate {
    func itemSelected(video: PlaylistVideo) {
        SceneDelegate.shared?.showVideoDetailWindow(video: video.convertedToVideo)
    }
}
