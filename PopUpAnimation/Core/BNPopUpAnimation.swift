//
//  BNPopUpAnimation.swift
//  PopUpAnimationDemo
//
//  Created by Guanliyuan on 2019/9/4.
//  Copyright © 2019 liangdong. All rights reserved.
//

import UIKit

public protocol BNPopUpAnimationPosition {
    var presentedViewFrame: CGRect { get }
}

open class BNPopUpAnimation: NSObject {
    
    //MARK: - open or public
    
    open func performPresentAnimate(context: UIViewControllerContextTransitioning) {
        context.completeTransition(true)
    }
    
    open func performDismissAnimate(context: UIViewControllerContextTransitioning) {
        context.completeTransition(true)
    }
    
    var animateState = AnimateState.presenting
    var backgroundStyle = BackgroundStyle.blurEffect(style: .init(style: .light), alpha: 0.9)
}

// MARK: - UIViewControllerAnimatedTransitioning
extension BNPopUpAnimation : UIViewControllerAnimatedTransitioning {
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if self.animateState == .presenting {
            self.performPresentAnimate(context: transitionContext)
        } else {
            self.performDismissAnimate(context: transitionContext)
        }
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension BNPopUpAnimation : UIViewControllerTransitioningDelegate {
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animateState = .presenting
        return self
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animateState = .dismissing
        return self
    }
    
    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BNPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: Type define
extension BNPopUpAnimation {
    
    enum AnimateState {
        case presenting, dismissing
    }
    
    enum BackgroundStyle {
        case color(UIColor)
        case blurEffect(style: UIBlurEffect, alpha: CGFloat)
    }
}
