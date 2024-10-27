//
//  HomeViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 27/10/24.
//

import UIKit
import KingFisher

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        setNaviBarRightButton(systemImageName: "magnifyingglass") {
            
        }
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: HomeVideoListCell.className, bundle: nil), forCellReuseIdentifier: HomeVideoListCell.className)
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
        cell.thumbnailImageView.kfIma =
        // https://www.google.com/url?sa=i&url=https%3A%2F%2Fdiamond.jp%2Farticles%2F-%2F342871&psig=AOvVaw2sRmMeZboLSPE6lTtJv51d&ust=1730141798057000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCPDMg9Cer4kDFQAAAAAdAAAAABAE
//        cell.titleLabel =
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
