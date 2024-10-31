//
//  MyPageSignInView.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 31/10/24.
//

import UIKit

class MyPageSignInView: UIView {
    
    @IBOutlet weak var signInButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        loadNib()
        setupUI()
    }

    private func setupUI() {
        signInButton.layer.cornerRadius = 16
        signInButton.backgroundColor = UIColor.dynamicColor(light: .systemBlue, dark: .blueButtonColor)
    }
}
