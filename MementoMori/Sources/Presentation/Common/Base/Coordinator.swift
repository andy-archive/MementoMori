//
//  Coordinator.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
    func didFinish(childCoordinator: Coordinator)
}

protocol Coordinator: AnyObject {
    var delegate: CoordinatorDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
    func finish()
    func popViewController()
    func dismissViewController()
    func presentAlertError(title: String?, message: String?, handler: (() -> Void)?)
    
    init(_ navigationController: UINavigationController)
}

extension Coordinator {
    
    func finish() {
        childCoordinators.removeAll()
        delegate?.didFinish(childCoordinator: self)
    }
    
    func popViewController() {
        self.navigationController.popViewController(animated: true)
    }
    
    func dismissViewController() {
        navigationController.dismiss(animated: true)
    }
    
    func presentAlertError(
        title: String? = nil,
        message: String? = "오류가 발생했습니다.",
        handler: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: "오류가 발생했습니다.",
            message: message,
            preferredStyle: .alert
        )
        let button = UIAlertAction(title: "확인", style: .default)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(button)
        alertController.addAction(cancel)
        
        navigationController.present(alertController, animated: true)
    }
}
