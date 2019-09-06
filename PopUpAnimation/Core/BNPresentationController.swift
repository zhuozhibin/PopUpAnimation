//
//  BNPresentationController.swift
//  PopUpAnimationDemo
//
//  Created by Guanliyuan on 2019/9/5.
//  Copyright © 2019 liangdong. All rights reserved.
//

import UIKit

class BNPresentationController: UIPresentationController {
    
    open override func presentationTransitionWillBegin() {
        guard self.backgroundView.superview == nil else { return }
        
        self.containerView?.insertSubview(self.backgroundView, at: 0)
        UIView.animate(withDuration: self.duration) {
            self.showBackgroundView()
        }
    }
    
    open override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: self.duration) {
            self.hideBackgroundView()
        }
    }
    
    open override var frameOfPresentedViewInContainerView: CGRect {
        if let frame = (presentedViewController as? BNPopUpAnimationPosition)?.presentedViewFrame  {
            return frame
        }
        
        let size = self.presentedViewController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        // the controller view using SnapKit constraints, leading to translatesAutoresizingMaskIntoConstraints = false
        self.presentedViewController.view.translatesAutoresizingMaskIntoConstraints = true
        
        return CGRect(origin: CGPoint(x: (UIScreen.main.bounds.size.width - size.width)*0.5, y: (UIScreen.main.bounds.size.height - size.height)*0.5), size: size)
    }
    
    open func showBackgroundView() {
        switch self.backgroundStyle {
        case .color(_):
            self.backgroundView.alpha = 1
        case .blurEffect(_, let alpha):
            self.backgroundView.alpha = alpha
        }
    }
    
    open func hideBackgroundView() {
        self.backgroundView.alpha = 0
    }
    
    var backgroundStyle = BNPopUpAnimation.BackgroundStyle.blurEffect(style: .init(style: .light), alpha: 0.9)
    var duration: TimeInterval = 0.5
    
    fileprivate lazy var backgroundView : UIView = {
        var view: UIView
        
        switch self.backgroundStyle {
        case .color(let color):
            view = UIView()
            view.backgroundColor = color
        case .blurEffect(let effect, _):
            view = UIVisualEffectView(effect: effect)
        }
        
        view.frame = UIScreen.main.bounds
        view.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    @objc public func close() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("[BNPresentationController] deinit")
    }
}
