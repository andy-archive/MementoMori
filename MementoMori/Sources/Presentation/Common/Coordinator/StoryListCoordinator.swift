//
//  StoryListCoordinator.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import UIKit

final class StoryListCoordinator: Coordinator {

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

extension StoryListCoordinator {
    
    func showStoryListViewController() {
        self.navigationController.pushViewController(StoryListViewController(), animated: true)
    }
}
