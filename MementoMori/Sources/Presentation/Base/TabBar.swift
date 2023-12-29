//
//  TabBarType.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import UIKit

enum TabBar: Int, CaseIterable {
    
    case storyList = 0
    case storyUpload
    case userProfile
    
    var tabBarItem: UITabBarItem {
        switch self {
        case .storyList:
            return UITabBarItem(
                title: "",
                image: Constant.Image.System.house,
                selectedImage: Constant.Image.System.houseFill
            )
        case .storyUpload:
            return UITabBarItem(
                title: "",
                image: Constant.Image.System.plusSquare,
                selectedImage: Constant.Image.System.plusSquareFill
            )
        case .userProfile:
            return UITabBarItem(
                title: "",
                image: Constant.Image.System.personCircle,
                selectedImage: Constant.Image.System.personCircleFill
            )
        }
    }
}
