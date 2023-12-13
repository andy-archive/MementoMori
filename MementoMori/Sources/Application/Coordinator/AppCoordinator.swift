//
//  AppCoordinator.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator]
    var signinModal: UINavigationController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.childCoordinators = []
        self.signinModal = UINavigationController()
        
        self.tabBarController.configureAppearance()
        self.navigationController.configureAppearance()
    }
    
    func start() {
        showStoryUploadViewController()
    }
}

extension AppCoordinator {
    
    //MARK: - SplashViewController
    func showStoryUploadViewController() {
        showAutoSigninViewController()
        configureTabBarController()
    }
    
    //MARK: - (Modal 1) AutoSignin
    private func showAutoSigninViewController() {
        let viewModel = AutoSigninViewModel(coordinator: self)
        let autoSigninViewController = AutoSigninViewController(viewModel: viewModel)
        let signinModal = UINavigationController(rootViewController: autoSigninViewController)
        
        self.signinModal.setNavigationBarHidden(false, animated: false)
        self.signinModal = signinModal
        self.signinModal.modalPresentationStyle = .fullScreen
        self.navigationController.present(self.signinModal, animated: true)
    }
    
    //MARK: - (Modal 2-1) UserSignin
    func showUserSigninViewController() {
        let viewModel = UserSigninViewModel(
            coordinator: self,
            userSigninUseCase: UserSigninUseCase(
                userAuthRepository: makeAuthRepository(),
                keychainRepository: makeKeychainRepository()
            )
        )
        let viewController = UserSigninViewController(viewModel: viewModel)
        self.signinModal.pushViewController(viewController, animated: true)
    }
    
    //MARK: - (Modal 2-2) UserJoin
    func showUserJoinViewController() {
        let viewController = UserJoinViewController(
            viewModel: UserJoinViewModel(
                coordinator: self,
                userJoinUseCase: UserJoinUseCase(
                    userAuthRepository: makeAuthRepository()
                )
            )
        )
        self.signinModal.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Repositories
    private func makeAuthRepository() -> UserAuthRepositoryProtocol {
        return UserAuthRepository()
    }
    
    private func makeKeychainRepository() -> KeychainRepositoryProtocol {
        return KeychainRepository()
    }
}

//MARK: - TabBarController
private extension AppCoordinator {
    
    //MARK: - TabBar
    func configureTabBar(_ tabBar: TabBar) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabBar.tabBarItem
        navigationController.setNavigationBarHidden(true, animated: false)
        connectTabBarController(tabBar, navigationController)
        return navigationController
    }
    
    //MARK: - TabBarController
    func configureTabBarController() {
        let tabBarList: [TabBar] = TabBar.allCases
        let navigationControllerList: [UINavigationController] = tabBarList.map { tabBar in
            configureTabBar(tabBar)
        }
        
        tabBarController.setViewControllers(navigationControllerList, animated: true)
        tabBarController.selectedIndex = TabBar.storyList.rawValue
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    //MARK: - NavigationController in TabBarController
    func connectTabBarController(_ tabBar: TabBar, _ navigationController: UINavigationController) {
        switch tabBar {
        case .storyList:
            makeStoryContentCoordinator(navigationController)
        case .storyUpload:
            makeStoryUploadCoordinator(navigationController)
        }
    }
    
    //MARK: - childCoordinators
    func makeStoryContentCoordinator(_ navigationController: UINavigationController) {
        let storyContentCoordinator = StoryContentCoordinator(navigationController)
        storyContentCoordinator.delegate = self
        storyContentCoordinator.start()
        childCoordinators.append(storyContentCoordinator)
    }
    
    func makeStoryUploadCoordinator(_ navigationController: UINavigationController) {
        let storyUploadCoordinator = StoryUploadCoordinator(navigationController)
        storyUploadCoordinator.delegate = self
        storyUploadCoordinator.start()
        childCoordinators.append(storyUploadCoordinator)
    }
}

//MARK: - CoordinatorDelegate
extension AppCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        if childCoordinator is StoryUploadCoordinator {
            tabBarController.selectedIndex = TabBar.storyList.rawValue
        }
    }
}
