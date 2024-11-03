//
//  MyPageViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 27/10/24.
//

import UIKit
import GoogleSignIn

class MyPageViewController: UIViewController {
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
            tableView.reloadData()
        }
    }
    
    @objc private func handleSignedInUserChange(notification: Notification) {
        print("MyPageVC handleSignedInUserChange notification: \(notification)")
        let isSignedIn = notification.userInfo?["signedInUserChanged"] as? GIDGoogleUser != nil
        handleSignInStatusChange(isSignedIn: isSignedIn)
    }
}

extension MyPageViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard SceneDelegate.shared?.signedInUser != nil else { return 0 }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellfor")
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageProfileCell.className, for: indexPath) as! MyPageProfileCell
            cell.profileIconImageView.kf.setImage(with: URL(string: "https://pbs.twimg.com/profile_images/1424201228997652486/QTsSmHDC_400x400.jpg"), placeholder: UIImage(systemName: "person.fill"))
            cell.nameLabel.text = "ウルトラ深瀬の激渋歌ってみた"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageHorizontalListCell.className, for: indexPath) as! MyPageHorizontalListCell
            cell.titleLabel.text = "History"
            cell.myPageHorizontalListDelegate = self
            return cell
        }
    }
}

extension MyPageViewController: MyPageHorizontalListDelegate {
    func itemSelected(at indexPath: IndexPath) {
        SceneDelegate.shared?.showVideoDetailWindow()
    }
}
