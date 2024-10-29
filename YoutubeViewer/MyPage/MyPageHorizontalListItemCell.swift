//
//  MyPageHorizontalListItemCell.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 29/10/24.
//

import UIKit

class MyPageHorizontalListItemCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        thumbnailImageView.layer.cornerRadius = 8
        let backgroundView = UIView(frame: contentView.frame)
        backgroundView.backgroundColor = .secondarySystemBackground
        selectedBackgroundView = backgroundView
    }
}
