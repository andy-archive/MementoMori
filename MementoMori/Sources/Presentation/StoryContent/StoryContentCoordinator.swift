//
//  StoryListCoordinator.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import UIKit

final class StoryContentCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        self.showStoryListViewController()
    }
}

//MARK: - ViewControllers
extension StoryContentCoordinator {
    
    func showStoryListViewController() {
        self.navigationController.pushViewController(
            StoryListViewController(
                viewModel: StoryListViewModel(
                    coordinator: self,
                    storyListUseCase: StoryListUseCase(
                        storyPostRepository: StoryPostRepository(),
                        keychainRepository: KeychainRepository()
                    )
                )
            ),
            animated: true
        )
    }
}

//MARK: - CoordinatorDelegate
extension StoryContentCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        self.finish()
    }
}
