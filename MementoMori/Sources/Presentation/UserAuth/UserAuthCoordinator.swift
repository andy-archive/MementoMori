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
//        showUserJoin()
    }
}

extension UserAuthCoordinator {
    
//    private func showUserJoin() {
//        let viewController = UserJoinViewController(
//            viewModel: UserJoinViewModel(
//                coordinator: self,
//                userJoinUseCase: UserJoinUseCase(
//                    userAuthRepository: makeAuthRepository()
//                )
//            )
//        )
//        self.navigationController.pushViewController(viewController, animated: true)
//    }
    
    private func makeAuthRepository() -> UserAuthRepositoryProtocol {
        return UserAuthRepository()
    }
}
