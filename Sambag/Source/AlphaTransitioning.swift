//
//  AlphaTransitioning.swift
//  Sambag
//
//  Created by Mounir Ybanez on 01/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

import UIKit

protocol AlphaTransitionDelegate: AnyObject {
    
    func preAnimation(transition: AlphaTransition)
    func postAnimation(transition: AlphaTransition)
}

extension AlphaTransitionDelegate {
    
    func preAnimation(transition: AlphaTransition) { }
    func postAnimation(transition: AlphaTransition) { }
}

class AlphaTransitioning: NSObject, UIViewControllerTransitioningDelegate {
    
    weak var delegate: AlphaTransitionDelegate?
    var duration: TimeInterval = 0.25
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = AlphaTransition(style: .presentation)
        transition.duration = duration
        transition.delegate = delegate
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = AlphaTransition(style: .dismissal)
        transition.duration = duration
        transition.delegate = delegate
        return transition
    }
}

class AlphaTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum Style {
        case presentation, dismissal
    }
    
    private(set) var style: Style = .presentation
    
    weak var delegate: AlphaTransitionDelegate?
    var duration: TimeInterval = 0.25
    
    init(style: Style) {
        super.init()
        self.style = style
    }
    
    func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        let presentedKey: UITransitionContextViewKey = style == .presentation ? .to : .from
        
        let presented = context.view(forKey: presentedKey)!
        let container = context.containerView
        
        var toAlpha: CGFloat = 1
        let animationOptions: UIView.AnimationOptions
        
        switch style {
        case .presentation:
            container.addSubview(presented)
            presented.alpha = 0
            animationOptions = .curveEaseIn
            
        case .dismissal:
            toAlpha = 0
            animationOptions = .curveEaseOut
        }
        
        delegate?.preAnimation(transition: self)
        
        presented.setNeedsLayout()
        presented.layoutIfNeeded()
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: animationOptions,
            animations: {
            presented.alpha = toAlpha
                
        }) { _ in
            context.completeTransition(true)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        delegate?.postAnimation(transition: self)
    }
}
