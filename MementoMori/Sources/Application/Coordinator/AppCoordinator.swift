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
        self.navigationController.configureAppearance()
        self.childCoordinators = []
    }
    
    func start() {
        showAutoSigninViewController()
    }
}

extension AppCoordinator {
    
    //MARK: - ViewController
    private func showAutoSigninViewController() {
        let autoSigninViewController = AutoSigninViewController(
            viewModel: AutoSigninViewModel(
                coordinator: self
            )
        )
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(autoSigninViewController, animated: true)
    }
    
    //MARK: - Coordinators
    func makeUserAuthCoordinator() {
        let userAuthCoordinator = UserAuthCoordinator(navigationController)
        userAuthCoordinator.delegate = self
        userAuthCoordinator.start()
        childCoordinators.append(userAuthCoordinator)
    }
    
    func makeTabBarCoordinator() {
        navigationController.popToRootViewController(animated: true)
        let tabBarCoordinator = TabBarCoordinator(navigationController)
        tabBarCoordinator.delegate = self
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
    
    //MARK: - Repositories
    private func makeAuthRepository() -> UserAuthRepositoryProtocol {
        return UserAuthRepository()
    }
    
    private func makeKeychainRepository() -> KeychainRepositoryProtocol {
        return KeychainRepository()
    }
}

//MARK: - CoordinatorDelegate
extension AppCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        navigationController.popToRootViewController(animated: true)
        if childCoordinator is TabBarCoordinator {
            makeUserAuthCoordinator()
        } else {
            makeTabBarCoordinator()
        }
    }
}
