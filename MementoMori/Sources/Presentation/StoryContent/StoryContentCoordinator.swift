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
    
    func showCommentDetailViewController() {
        let viewModel = CommentDetailViewModel(coordinator: self)
        let viewController = CommentDetailViewController(viewModel: viewModel)
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [
                .custom(identifier: .medium, resolver: { context in
                    return UIScreen.main.bounds.height * 0.7
                }),
                .custom(identifier: .large, resolver: { context in
                    return UIScreen.main.bounds.height * 0.9
                }),
            ]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.preferredCornerRadius = 25
        }
        navigationController.present(viewController, animated: true)
    }
}
