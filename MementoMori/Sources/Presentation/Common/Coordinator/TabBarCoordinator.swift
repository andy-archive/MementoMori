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
        let tabBarList: [TabBarType] = TabBarType.allCases
        let navigationControllers: [UINavigationController] = tabBarList.map { tabBar in
            self.configureTabBar(of: tabBar)
        }
        
        self.configureTabController(of: navigationControllers)
    }
}

extension TabBarCoordinator {
    
    func configureTabBar(of tabBar: TabBarType) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabBar.tabBarItem
        navigationController.setNavigationBarHidden(false, animated: false)
        connectTabCoordinator(of: tabBar, to: navigationController)
        return navigationController
    }
    
    func configureTabController(of viewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(viewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarType.storyList.rawValue
        self.tabBarController.configureAppearance()
        self.navigationController.configureAppearance()
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(tabBarController, animated: true)
    }
    
    func connectTabCoordinator(of tabBar: TabBarType, to navigationController: UINavigationController) {
        switch tabBar {
        case .storyList:
            self.showStoryListFlow(to: navigationController)
        }
    }
    
    func showStoryListFlow(to navigationController: UINavigationController) {
        let storyListCoordinator = StoryListCoordinator(navigationController)
        storyListCoordinator.start()
    }
}

//MARK: CoordinatorDelegate

extension TabBarCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        self.navigationController.popToRootViewController(animated: false)
        self.finish()
    }
}
