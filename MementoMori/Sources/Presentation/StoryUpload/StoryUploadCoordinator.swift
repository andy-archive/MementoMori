//
//  StoryUploadCoordinator.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/7/23.
//

import UIKit

final class StoryUploadCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        self.showStoryUploadViewController()
    }
}

extension StoryUploadCoordinator {
    
    func showStoryUploadViewController() {
        self.navigationController.pushViewController(
            StoryUploadViewController(), animated: true
        )
    }
}
