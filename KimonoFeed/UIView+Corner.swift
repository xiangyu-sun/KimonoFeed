//
//  UIView+Corner.swift
//  KimonoFeed
//
//  Created by 孙翔宇 on 12/30/18.
//  Copyright © 2018 孙翔宇. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    
}
