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
        let viewModel = StoryUploadViewModel(
            coordinator: self,
            storyUploadUseCase: StoryUploadUseCase(
                storyPostRepository: StoryPostRepository()
            )
        )
        let viewController =  StoryUploadViewController(
            viewModel: viewModel,
            imagePicker: ImagePickerController()
        )
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
