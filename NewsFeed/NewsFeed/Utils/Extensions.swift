//
//  Extensions.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 04/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    func installBlurEffect() {
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        var blurFrame = bounds
        blurFrame.size.height += statusBarHeight
        blurFrame.origin.y -= statusBarHeight
        let blurView  = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.isUserInteractionEnabled = false
        blurView.frame = blurFrame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        blurView.layer.zPosition = -1
    }
}

