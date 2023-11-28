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
    var childCoordinators: [Coordinator]
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.navigationController.configureAppearance()
    }
    
    func start() {
        showUserSignin()
    }
}

extension AppCoordinator {
    
    private func showContentList() {
        let viewController = ContentListViewController()
        self.navigationController.viewControllers.removeAll()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func showUserSignin() {
        let viewController = UserSigninViewController(
            viewModel: UserSigninViewModel(
                coordinator: self,
                userSigninUseCase: UserSigninUseCase(
                    userAuthRepository: makeAuthRepository()
                )
            )
        )
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func connectUserJoin() {
        let viewController = UserJoinViewController(
            viewModel: UserJoinViewModel(
                coordinator: self,
                userJoinUseCase: UserJoinUseCase(
                    userAuthRepository: makeAuthRepository()
                )
            )
        )
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showTabBarFlow() {
        self.navigationController.popToRootViewController(animated: true)
        let tabBarCoordinator = TabBarCoordinator(self.navigationController)
        tabBarCoordinator.delegate = self
        tabBarCoordinator.start()
        self.childCoordinators.append(tabBarCoordinator)
    }
    
    private func makeAuthRepository() -> UserAuthRepositoryProtocol {
        return UserAuthRepository()
    }
}

extension AppCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        self.navigationController.popToRootViewController(animated: true)
        
        if childCoordinator is UserAuthCoordinator {
            self.showTabBarFlow()
        }
    }
}
