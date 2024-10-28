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
    @IBOutlet weak var dummyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        videoImageView.kf.setImage(with: URL(string: "https://www.tabemaro.jp/wp-content/uploads/2023/06/27910319_m-1700x1133.jpg"))
        videoImageView.layer.cornerRadius = 6
        dummyImageView.kf.setImage(with: URL(string: "https://www.tabemaro.jp/wp-content/uploads/2023/06/27910319_m-1700x1133.jpg"))
        dummyImageView.layer.cornerRadius = 6
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("dummyImageViewのframe: \(dummyImageView.frame)")
    }
    
    func updateImageViewFrame(_ frame: CGRect) {
        videoImageView.frame = frame
    }
}
