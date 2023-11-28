//
//  TabBarType.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import UIKit

enum TabBar: Int, CaseIterable {
    
    case storyList = 0
    
    var tabBarItem: UITabBarItem {
        switch self {
        case .storyList:
            return UITabBarItem(
                title: Constant.Text.TabBar.house,
                image: Constant.Image.System.house,
                selectedImage: Constant.Image.System.houseFill
            )
        }
    }
}
