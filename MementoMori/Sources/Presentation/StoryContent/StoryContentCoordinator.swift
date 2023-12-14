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
        let useCase = StoryListUseCase(
            storyPostRepository: StoryPostRepository(),
            keychainRepository: KeychainRepository()
        )
        let viewModel = StoryListViewModel(
            coordinator: self,
            storyListUseCase: useCase
        )
        let viewController =  StoryListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}
