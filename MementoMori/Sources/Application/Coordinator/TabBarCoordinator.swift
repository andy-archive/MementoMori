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
        let tabBarList: [TabBar] = TabBar.allCases
        let navigationControllers: [UINavigationController] = tabBarList.map { tabBar in
            configureTabBar(of: tabBar)
        }
        configureTabBarController(of: navigationControllers)
    }
}

private extension TabBarCoordinator {
    
    //MARK: - TabBar
    func configureTabBar(of tabBar: TabBar) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabBar.tabBarItem
        navigationController.setNavigationBarHidden(true, animated: false)
        connectTabCoordinator(of: tabBar, to: navigationController)
        return navigationController
    }
    
    //MARK: - TabBarController & NavigationController
    func configureTabBarController(of viewControllers: [UIViewController]) {
        tabBarController.setViewControllers(viewControllers, animated: true)
        tabBarController.selectedIndex = TabBar.storyList.rawValue
        tabBarController.configureAppearance()
        navigationController.configureAppearance()
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    //MARK: - TabBarCoordinator
    func connectTabCoordinator(of tabBar: TabBar, to navigationController: UINavigationController) {
        switch tabBar {
        case .storyList:
            makeStoryContentCoordinator(navigationController)
        case .storyUpload:
            makeStoryUploadCoordinator(navigationController)
        }
    }
    
    //MARK: - other Coordinators
    func makeStoryContentCoordinator(_ navigationController: UINavigationController) {
        let storyListCoordinator = StoryContentCoordinator(navigationController)
        storyListCoordinator.delegate = self
        storyListCoordinator.start()
        childCoordinators.append(storyListCoordinator)
    }
    
    func makeStoryUploadCoordinator(_ navigationController: UINavigationController) {
        let storyUploadCoordinator = StoryUploadCoordinator(navigationController)
        storyUploadCoordinator.delegate = self
        storyUploadCoordinator.start()
        childCoordinators.append(storyUploadCoordinator)
    }
}

//MARK: - CoordinatorDelegate
extension TabBarCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        navigationController.popToRootViewController(animated: true)
        finish()
    }
}
