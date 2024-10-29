//
//  MyPageHorizontalListCell.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 29/10/24.
//

import UIKit
import Kingfisher

protocol MyPageHorizontalListDelegate: AnyObject {
    func itemSelected(at indexPath: IndexPath)
}

class MyPageHorizontalListCell: UITableViewCell {
    weak var myPageHorizontalListDelegate: MyPageHorizontalListDelegate?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
        
        viewAllButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        viewAllButton.layer.borderWidth = 1
        viewAllButton.layer.cornerRadius = 16
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: MyPageHorizontalListItemCell.className, bundle: nil), forCellWithReuseIdentifier: MyPageHorizontalListItemCell.className)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.showsHorizontalScrollIndicator = false
    }
}

extension MyPageHorizontalListCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageHorizontalListItemCell.className, for: indexPath) as! MyPageHorizontalListItemCell
        cell.thumbnailImageView.kf.setImage(
            with: URL(string: "https://dol.ismcdn.jp/mwimgs/2/7/650/img_2753004f183b1b28893cb3dc0dc4412a263663.jpg"),
            placeholder: UIImage(systemName: "photo")
        )
        cell.titleLabel.text = "鉄道で行くスイス】アルプス山脈のふもと超絶景山岳リゾートへの車窓の旅“3つのルート” | 地球の歩き方ニュース＆レポート | ダイヤモンド・オンライン"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myPageHorizontalListDelegate?.itemSelected(at: indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension MyPageHorizontalListCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
