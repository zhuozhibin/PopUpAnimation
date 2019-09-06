//
//  BNPopUpAnimationExtensions.swift
//  PopUpAnimationDemo
//
//  Created by Guanliyuan on 2019/9/5.
//  Copyright © 2019 liangdong. All rights reserved.
//

import UIKit

extension UIViewController {
    open var popUpAnimation: BNPopUpAnimation? {
        get {
            return objc_getAssociatedObject(self, "BNPopUpAnimation") as? BNPopUpAnimation
        }
        
        set {
            objc_setAssociatedObject(self, "BNPopUpAnimation", newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            guard let animation = newValue else { return }
            
            self.transitioningDelegate = animation
            self.modalPresentationStyle = .custom
        }
    }
}
