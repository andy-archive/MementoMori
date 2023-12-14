//
//  AppCoordinator.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    //MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var tabBarController: TabController
    var childCoordinators: [Coordinator]
    var signinModal: UINavigationController
    
    //MARK: - Initializer
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = TabController()
        self.childCoordinators = []
        self.signinModal = UINavigationController()
    }
    
    //MARK: - Protocol Method
    func start() {
        configureCoordinator()
        showSplashViewController()
    }
}

//MARK: - configure
private extension AppCoordinator {
    
    //MARK: - (0) AppCoordinator
    func configureCoordinator() {
        let tabBarList: [TabBar] = TabBar.allCases
        let navigationControllerList: [UINavigationController] = tabBarList.map { tabBar in
            configureTabBar(tabBar)
        }
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.configureAppearance()
        
        tabBarController.setViewControllers(navigationControllerList, animated: true)
        tabBarController.selectedIndex = TabBar.storyList.rawValue
        tabBarController.configureAppearance()
        
        signinModal = UINavigationController()
        signinModal.setNavigationBarHidden(false, animated: false)
        signinModal.modalPresentationStyle = .fullScreen
    }
}

//MARK: - (1 ~ 2) SplashViewController x SigninModal
extension AppCoordinator {
    
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
    
    //MARK: - (1+) SigninModal
    func connectSigninModal() {
        navigationController.present(signinModal, animated: true)
    }
    
    func disconnectSigninModal() {
        navigationController.dismiss(animated: true)
    }
    
    //MARK: - (1+) AutoSigninViewController (Modal 1)
    func showAutoSigninViewController() {
        let viewModel = AutoSigninViewModel(coordinator: self)
        let viewController = AutoSigninViewController(viewModel: viewModel)
        signinModal.pushViewController(viewController, animated: true)
    }
    
    //MARK: - (1+) UserSigninViewController (Modal 2)
    func showUserSigninViewController() {
        let useCase = UserSigninUseCase(
            userAuthRepository: makeAuthRepository(),
            keychainRepository: makeKeychainRepository()
        )
        let viewModel = UserSigninViewModel(coordinator: self, userSigninUseCase: useCase)
        let viewController = UserSigninViewController(viewModel: viewModel)
        signinModal.pushViewController(viewController, animated: true)
    }
    
    //MARK: - (1+) UserJoinViewController (Modal 3)
    func showUserJoinViewController() {
        let useCase = UserJoinUseCase(userAuthRepository: makeAuthRepository())
        let viewModel = UserJoinViewModel(coordinator: self, userJoinUseCase: useCase)
        let viewController = UserJoinViewController(viewModel: viewModel)
        signinModal.pushViewController(viewController, animated: true)
    }
    
    //MARK: - (2) TabBarController
    func showTabBarController() {
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabBarController, animated: false)
    }
    
    //MARK: - (DI) Repositories
    private func makeAuthRepository() -> UserAuthRepositoryProtocol {
        return UserAuthRepository()
    }
    
    private func makeKeychainRepository() -> KeychainRepositoryProtocol {
        return KeychainRepository()
    }
}

//MARK: - (3 ~ 5) TabCoordinator
private extension AppCoordinator {
    
    //MARK: - (3) TabBar
    func configureTabBar(_ tabBar: TabBar) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabBar.tabBarItem
        navigationController.setNavigationBarHidden(true, animated: false)
        connectTabBarController(tabBar, navigationController)
        return navigationController
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
