//
//  UITextField+.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/14.
//

import UIKit

extension UITextField {
    func paddingOnLeft(inset: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
