//
//  UserAuthCoordinator.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import UIKit

final class UserAuthCoordinator: Coordinator {
    
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        showUserSigninViewController()
    }
}

//MARK: - showViewController
extension UserAuthCoordinator {
    
    func showUserSigninViewController() {
        let viewController = UserSigninViewController(
            viewModel: UserSigninViewModel(
                coordinator: self,
                userSigninUseCase: UserSigninUseCase(
                    userAuthRepository: makeAuthRepository(),
                    keychainRepository: makeKeychainRepository()
                )
            )
        )
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showUserJoinViewController() {
        let viewController = UserJoinViewController(
            viewModel: UserJoinViewModel(
                coordinator: self,
                userJoinUseCase: UserJoinUseCase(
                    userAuthRepository: makeAuthRepository()
                )
            )
        )
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func makeAuthRepository() -> UserAuthRepositoryProtocol {
        return UserAuthRepository()
    }
    
    private func makeKeychainRepository() -> KeychainRepositoryProtocol {
        return KeychainRepository()
    }
}
