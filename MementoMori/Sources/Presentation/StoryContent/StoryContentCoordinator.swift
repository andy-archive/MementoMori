//
//  StoryListCoordinator.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import UIKit

final class StoryContentCoordinator: Coordinator {
    
    //MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    //MARK: - Initializer
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    //MARK: - Start
    func start() {
        showStoryListViewController()
    }
}

//MARK: - ViewControllers
extension StoryContentCoordinator {
    
    func showStoryListViewController() {
        let useCase = StoryListUseCase(
            storyPostRepository: StoryPostRepository(),
            keychainRepository: makeKeychainRepository()
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
        
        viewController.changeToSheetPresentation()
        navigationController.present(viewController, animated: true)
    }
}

//MARK: - Repositories
private extension StoryContentCoordinator {
    
    func makeKeychainRepository() -> KeychainRepositoryProtocol {
        return KeychainRepository.shared
    }
}
