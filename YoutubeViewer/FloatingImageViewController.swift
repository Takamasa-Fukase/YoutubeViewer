//
//  FloatingImageViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 28/10/24.
//

import UIKit
import Kingfisher

class FloatingImageViewController: UIViewController {
    
    @IBOutlet weak var videoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("FloatingImageViewController didLoad")

        videoImageView.kf.setImage(with: URL(string: "https://www.tabemaro.jp/wp-content/uploads/2023/06/27910319_m-1700x1133.jpg"))
    }
}