//
//  UIColor+Extension.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 31/10/24.
//

import UIKit

extension UIColor {
    static var blueButtonColor: UIColor {
        return .init(red: 92/255, green: 164/255, blue: 248/255, alpha: 1)
    }
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { (traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return light
            case .dark:
                return dark
            default:
                return light
            }
        }
    }
}
