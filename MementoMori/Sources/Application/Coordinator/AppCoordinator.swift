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
    var tabBarController: TabController
    var childCoordinators: [Coordinator]
    var signinModal: UINavigationController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = TabController()
        self.childCoordinators = []
        self.signinModal = UINavigationController()
    }
    
    func start() {
        configureCoordinator()
    }
}

//MARK: - (0 ~ 1) AppCoordinator
extension AppCoordinator {
    
    //MARK: - (0) AppCoordinator
    func configureCoordinator() {
        tabBarController.configureAppearance()
        navigationController.configureAppearance()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        showSplashViewController()
        presentAutoSigninModal()
    }
    
    //MARK: - (1) SplashViewController
    func showSplashViewController() {
        let userSigninUseCase = UserSigninUseCase(
            userAuthRepository: makeAuthRepository(),
            keychainRepository: makeKeychainRepository()
        )
        let viewModel = SplashViewModel(
            coordinator: self,
            userSigninUseCase: userSigninUseCase
        )
        let viewController = SplashViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    //MARK: - (1+) AutoSigninViewController (Modal 1)
    private func presentAutoSigninModal() {
        let viewModel = AutoSigninViewModel(coordinator: self)
        let viewController = AutoSigninViewController(viewModel: viewModel)
        let modal = UINavigationController(rootViewController: viewController)
        
        self.signinModal = modal
        self.signinModal.setNavigationBarHidden(false, animated: false)
        self.signinModal.modalPresentationStyle = .fullScreen
        self.navigationController.present(self.signinModal, animated: true)
    }
    
    //MARK: - (1+) UserSigninViewController (Modal 2)
    func showUserSigninViewController() {
        let useCase = UserSigninUseCase(
            userAuthRepository: makeAuthRepository(),
            keychainRepository: makeKeychainRepository()
        )
        let viewModel = UserSigninViewModel(coordinator: self, userSigninUseCase: useCase)
        let viewController = UserSigninViewController(viewModel: viewModel)
        self.signinModal.pushViewController(viewController, animated: true)
    }
    
    //MARK: - (1+) UserJoinViewController (Modal 2)
    func showUserJoinViewController() {
        let useCase = UserJoinUseCase(userAuthRepository: makeAuthRepository())
        let viewModel = UserJoinViewModel(coordinator: self, userJoinUseCase: useCase)
        let viewController = UserJoinViewController(viewModel: viewModel)
        self.signinModal.pushViewController(viewController, animated: true)
    }
    
    private func makeAuthRepository() -> UserAuthRepositoryProtocol {
        return UserAuthRepository()
    }
    
    private func makeKeychainRepository() -> KeychainRepositoryProtocol {
        return KeychainRepository()
    }
}

//MARK: - (2 ~ 4) TabCoordinator
private extension AppCoordinator {
    
    //MARK: - TabBar
    func configureTabBar(_ tabBar: TabBar) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabBar.tabBarItem
        navigationController.setNavigationBarHidden(true, animated: false)
        connectTabBarController(tabBar, navigationController)
        return navigationController
    }
    
    //MARK: - (2) TabBarController
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
    
    //MARK: - (3) NavigationController in TabBarController
    func connectTabBarController(_ tabBar: TabBar, _ navigationController: UINavigationController) {
        switch tabBar {
        case .storyList:
            makeStoryContentCoordinator(navigationController)
        case .storyUpload:
            makeStoryUploadCoordinator(navigationController)
        }
    }
    
    //MARK: - (4) childCoordinators
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
