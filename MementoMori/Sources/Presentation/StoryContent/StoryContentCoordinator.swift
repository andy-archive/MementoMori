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

extension StoryContentCoordinator {
    
    func showStoryListViewController() {
        self.navigationController.pushViewController(
            StoryListViewController(
                viewModel: StoryListViewModel()
            ),
            animated: true
        )
    }
}
