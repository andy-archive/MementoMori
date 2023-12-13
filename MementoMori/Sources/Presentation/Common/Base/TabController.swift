//
//  TabController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/13/23.
//

import UIKit

final class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
}

extension TabController: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        animationControllerForTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        
        return MyTransition(viewControllers: tabBarController.viewControllers)
    }
}

final class MyTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let viewControllers: [UIViewController]?
    private let transitionDuration: Double = 0.3
    
    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }
    
    //MARK: - private functions
    private func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = self.viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
    
    //MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        
        return TimeInterval(transitionDuration)
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        guard let fromVC = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.from),
              let fromView = fromVC.view,
              let fromIndex = getIndex(forViewController: fromVC),
              let toVC = transitionContext.viewController(
                forKey: UITransitionContextViewControllerKey.to),
              let toView = toVC.view,
              let toIndex = getIndex(forViewController: toVC)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        
        fromFrameEnd.origin.x = toIndex > fromIndex ?
        frame.origin.x - frame.width :
        frame.origin.x + frame.width
        
        toFrameStart.origin.x = toIndex > fromIndex ? 
        frame.origin.x + frame.width :
        frame.origin.x - frame.width
        
        toView.frame = toFrameStart
        
        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            UIView.animate(
                withDuration: self.transitionDuration,
                animations: {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            }, completion: { success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            })
        }
    }
}
