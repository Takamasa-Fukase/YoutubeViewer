//
//  MyPageHorizontalListCell.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 29/10/24.
//

import UIKit

class MyPageHorizontalListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewAllButton.layer.borderColor = UIColor.label.cgColor
        viewAllButton.layer.borderWidth = 1
        viewAllButton.layer.cornerRadius = 16
    }
}
