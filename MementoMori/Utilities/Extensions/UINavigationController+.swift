//
//  UINavigationController+.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/13.
//

import UIKit

extension UINavigationController {
    func configureAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = Constant.Color.groupedBackground
        appearance.largeTitleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 30),
            .foregroundColor: Constant.Color.label
        ]
        appearance.titleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 17),
            .foregroundColor: Constant.Color.label
        ]
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
