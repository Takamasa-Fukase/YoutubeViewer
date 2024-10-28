//
//  VideoDetailViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 28/10/24.
//

import UIKit
import Kingfisher
import PanModal

class VideoDetailViewController: UIViewController {
    var isViewAppeared = false
    var isLongForm = false
    
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoImageView.kf.setImage(with: URL(string: "https://www.tabemaro.jp/wp-content/uploads/2023/06/27910319_m-1700x1133.jpg"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isViewAppeared = true
        panModalSetNeedsLayoutUpdate()
    }
}

extension VideoDetailViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    
    var topOffset: CGFloat {
        return 0.0
    }

    var springDamping: CGFloat {
        return 1.0
    }

    var transitionDuration: Double {
        return 0.4
    }

    var transitionAnimationOptions: UIView.AnimationOptions {
        return [.allowUserInteraction, .beginFromCurrentState]
    }

    var shouldRoundTopCorners: Bool {
        return false
    }

    var showDragIndicator: Bool {
        return false
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeight
    }
    
    var shortFormHeight: PanModalHeight {
        if isViewAppeared {
            return .contentHeight(200)
        }else {
            return .maxHeight
        }
    }
    
    var allowsTapToDismiss: Bool {
        return false
    }
    
    var allowsDragToDismiss: Bool {
        return !isLongForm
    }
    
    func willTransition(to state: PanModalPresentationController.PresentationState) {
        if state == .longForm {
            isLongForm = true
        }else {
            isLongForm = false
        }
    }
}
