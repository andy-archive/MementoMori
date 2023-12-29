//
//  UserProfileCoordinator.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/19/23.
//

import UIKit

final class UserProfileCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        self.showUserProfileViewController()
    }
}

extension UserProfileCoordinator {
    
    func showUserProfileViewController() {
//    let useCase = UserProfileUseCase: UserProfileUseCase()
        let viewModel = UserProfileViewModel(
            coordinator: self
        )
        let viewController =  UserProfileViewController(
            viewModel: viewModel
        )
        navigationController.pushViewController(viewController, animated: true)
    }
}
