//
//  BNPopUpAnimationSimple.swift
//  PopUpAnimationDemo
//
//  Created by Guanliyuan on 2019/9/5.
//  Copyright © 2019 liangdong. All rights reserved.
//

import UIKit

class BNPopUpAnimationSimple: BNPopUpAnimation {
    
    //MARK: - open or public
    
    open override func performPresentAnimate(context: UIViewControllerContextTransitioning) {
        guard
            //let fromController = context.viewController(forKey: .from),
            let toController = context.viewController(forKey: .to)
            else { return }
        
        guard
            //let fromView = fromController.view,
            let toView = toController.view
            else { return }
        
        toController.view.frame = (toController as? BNPopUpAnimationPosition)?.presentedViewFrame ?? CGRect.zero
        context.containerView.addSubview(toView)
        
        apply(animates: self.presentAnimateParam.animateTypes, to: toView)
        
        UIView.animate(withDuration: self.presentAnimateParam.duration, delay: 0, usingSpringWithDamping: self.presentAnimateParam.dampingRatio, initialSpringVelocity: self.presentAnimateParam.velocity, options: self.presentAnimateParam.options, animations: {
            self.apply(animates: self.presentAnimateParam.animateEndTypes, to: toView)
        }) { (complete) in
            if context.transitionWasCancelled {
                context.completeTransition(false)
            } else {
                context.completeTransition(complete)
            }
        }
    }
    
    open override func performDismissAnimate(context: UIViewControllerContextTransitioning) {
        
        guard
            let fromController = context.viewController(forKey: .from)//,
            //let toController = context.viewController(forKey: .to)
            else { return }
        
        guard
            let fromView = fromController.view//,
            //let toView = toController.view
            else { return }
        
        UIView.animate(withDuration: self.presentAnimateParam.duration, delay: 0, usingSpringWithDamping: self.presentAnimateParam.dampingRatio, initialSpringVelocity: self.presentAnimateParam.velocity, options: self.presentAnimateParam.options, animations: {
            self.apply(animates: self.dismissAnimateParam?.animateTypes ?? self.presentAnimateParam.animateTypes, to: fromView)
            //toView.transform = CGAffineTransform.identity
        }) { (complete) in
            if context.transitionWasCancelled {
                context.completeTransition(false)
            } else {
                context.completeTransition(complete)
            }
        }
    }
    
    public var presentAnimateParam = AnimateParam()
    public var dismissAnimateParam : AnimateParam?
    
    //MARK: - internal fileprivate private
    
    func apply(animates: [AnimateType], to view: UIView) {
        animates.forEach { (animate) in
            animate.apply(to: view)
        }
    }
    
    deinit {
        print("[BNPopUpAnimationSimple] deinit")
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension BNPopUpAnimationSimple {
    open override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if self.animateState == .presenting {
            return self.presentAnimateParam.duration
        } else {
            return self.dismissAnimateParam?.duration ?? self.presentAnimateParam.duration;
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension BNPopUpAnimationSimple {
    open override func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = BNPresentationController(presentedViewController: presented, presenting: presenting)
        controller.backgroundStyle = self.backgroundStyle
        if self.animateState == .presenting {
            controller.duration = self.presentAnimateParam.duration
        } else {
            controller.duration = self.dismissAnimateParam?.duration ?? self.presentAnimateParam.duration
        }
        
        return controller
    }
}

// MARK: Type define
extension BNPopUpAnimationSimple {
    public struct AnimateParam {
        var duration: TimeInterval = 0.25
        var delay: TimeInterval = 0
        var dampingRatio: CGFloat = 1
        var velocity: CGFloat = 0
        var options: UIView.AnimationOptions = .curveEaseInOut
        
        var animateTypes: [AnimateType] = [.alpha(0), .translation(point: CGPoint(x: 0, y: 500))]
        var animateEndTypes: [AnimateType] = [.alpha(1), .transform(transform: CGAffineTransform.identity)]
    }
    
    enum AnimateType {
        case transform(transform: CGAffineTransform)
        case translation(point: CGPoint)
        case scale(CGFloat)
        case alpha(CGFloat)
        
        func apply(to view: UIView) {
            switch self {
            case .transform(let transform):
                view.transform = transform
            case .translation(let point):
                view.transform = view.transform.concatenating(CGAffineTransform(translationX:point.x , y: point.y))
            case .scale(let scale):
                view.transform = view.transform.concatenating(CGAffineTransform(scaleX: scale, y: scale))
            case .alpha(let alpha):
                view.alpha = alpha
            }
        }
    }
}
