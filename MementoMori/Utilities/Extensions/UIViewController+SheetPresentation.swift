//
//  UIViewController+SheetPresentation.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/15/23.
//

import UIKit

extension UIViewController {
    
    func changeToSheetPresentation() {
        if let sheet = self.sheetPresentationController {
            sheet.detents = [
                .custom(identifier: .medium, resolver: { context in
                    return UIScreen.main.bounds.height * 0.6
                }),
                .custom(identifier: .large, resolver: { context in
                    return UIScreen.main.bounds.height * 0.9
                }),
            ]
            sheet.selectedDetentIdentifier = .large
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.preferredCornerRadius = 25
        }
    }
}
