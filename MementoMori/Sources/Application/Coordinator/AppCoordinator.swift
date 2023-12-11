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
        presentModalAutoSigninViewController()
    }
}

extension AppCoordinator {
    
    //MARK: - AutoSignin (Modal)
    private func presentModalAutoSigninViewController() {
        let autoSigninViewController = AutoSigninViewController(
            viewModel: AutoSigninViewModel(
                coordinator: self
            )
        )
        autoSigninViewController.modalPresentationStyle = .fullScreen
        navigationController.present(autoSigninViewController, animated: true)
    }
    
    //MARK: - Coordinators
    func makeUserAuthCoordinator() {
        navigationController.setNavigationBarHidden(true, animated: false)
        let userAuthCoordinator = UserAuthCoordinator(navigationController)
        userAuthCoordinator.delegate = self
        userAuthCoordinator.start()
        childCoordinators.append(userAuthCoordinator)
    }
    
    func makeTabBarCoordinator() {
        presentModalAutoSigninViewController()
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
        navigationController.dismiss(animated: true)
        navigationController.popToRootViewController(animated: true)
        if childCoordinator is UserAuthCoordinator {
            makeTabBarCoordinator()
        } else {
            makeUserAuthCoordinator()
        }
    }
}
