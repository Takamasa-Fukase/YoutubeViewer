//
//  MyPageProfileCell.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 29/10/24.
//

import UIKit
import Kingfisher

class MyPageProfileCell: UITableViewCell {

    @IBOutlet weak var profileIconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileIconImageView.layer.cornerRadius = 36
    }
}
