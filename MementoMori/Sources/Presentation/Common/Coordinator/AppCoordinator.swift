//
//  AppCoordinator.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private let window: UIWindow?
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    private func setUp(window: UIWindow?) {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func start() {
        setUp(window: window)
        showUserJoin()
        configureTabBar()
        navigationController.configureAppearance()
    }
}

extension AppCoordinator {
    
    private func showContentList() {
        let viewController = ContentListViewController()
        self.navigationController.viewControllers.removeAll()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func showUserJoin() {
        let viewController = UserJoinViewController(viewModel: UserJoinViewModel(userJoinUseCase: )
                coordinator: self
            )
        )
        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func configureTabBar() {
        self.navigationController.popToRootViewController(animated: true)
        let tabBarCoordinator = TabBarCoordinator(self.navigationController)
        tabBarCoordinator.delegate = self
        tabBarCoordinator.start()
        self.childCoordinators.append(tabBarCoordinator)
    }
}

extension AppCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        self.navigationController.popToRootViewController(animated: true)
    }
}
