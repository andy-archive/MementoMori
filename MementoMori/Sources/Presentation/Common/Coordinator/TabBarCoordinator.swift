//
//  TabBarCoordinator.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    weak var delegate: CoordinatorDelegate?
    
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator]
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.childCoordinators = []
    }
    
    func start() {
        if let items = tabBarController.tabBar.items {
            items[0].image = Constant.Image.System.house
            items[0].selectedImage = Constant.Image.System.houseFill
            items[0].title = Constant.Text.TabBar.house
        }
        
        tabBarController.configureAppearance()
    }
}
