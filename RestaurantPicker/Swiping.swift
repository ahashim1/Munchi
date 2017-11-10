//
//  Swiping.swift
//  RestaurantPicker
//
//  Created by Ali Hashim on 11/2/17.
//  Copyright © 2017 Ali Hashim. All rights reserved.
//

import UIKit
protocol SwipingDelegate {
    func swipedLeft()
    func swipedRight()
}

class Swiping: UIPanGestureRecognizer{
    var swipingDelegate: SwipingDelegate?
    enum swipeDirection{
        case none
        case right
        case left
    }
    func swipeAction(view: UIView){
        let translation = self.translation(in: view.superview)
        let direction: swipeDirection = translation.x > 0 ? .right: .left

        switch state{
            
        case.changed:
            UIView.animate(withDuration: 0.1, animations: {
                view.backgroundColor = direction == .right ? .green: .red
            }, completion: nil)
            view.transform = transform(view: view, with: translation)

        case .ended:
            
            
            if abs(translation.x) < view.frame.width/3 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations: {
                    view.transform = .identity
                    view.backgroundColor = UIColor(red: 146/255, green: 13/255, blue: 0, alpha: 1)

                }, completion: { (true) in
                    
                    
                })
            }else{
                view.backgroundColor = UIColor(red: 146/255, green: 13/255, blue: 0, alpha: 1)

                swipe(view, direction)
            }
            
            
        default:
            break
        }
        
    }
    
    func transform(view: UIView, with translation: CGPoint) -> CGAffineTransform{
        let moveBy = CGAffineTransform(translationX: translation.x, y: translation.y)
        let rotation = -sin(translation.x / (view.frame.width * 4))
        return moveBy.rotated(by: rotation)
    }
    
    func swipe(_ view: UIView, _ direction: swipeDirection){
        var directionWidth = view.frame.width * 2
        let directionHeight = -1*view.frame.height
        if direction == .left{
            directionWidth *= -1
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            view.transform = CGAffineTransform(translationX: directionWidth, y: directionHeight).rotated(by: -sin(directionWidth / (view.frame.width * 4)))
            
        }) { (animated) in
            direction == .right ? self.swipingDelegate?.swipedRight(): self.swipingDelegate?.swipedLeft()
        }
    }
}


