//
//  HolyView.swift
//  HolyView
//
//  Created by ruslanas on 9/2/15.
//  Copyright (c) 2015 Ruslanas Kudriavcevas. All rights reserved.
//

import UIKit

class HolyView: UIView {
    
    typealias CompletionBlock = (dismissed: Bool) -> Void
    
    private var completion: CompletionBlock?
    private let tapRec = UITapGestureRecognizer()
    private var holePosition = CGPointZero
    private var holeRadius: CGFloat = 0.0
    
    class func show(bgColor: UIColor, position: CGPoint, radius: CGFloat, message: String?, completion: CompletionBlock) {
        if let window = UIApplication.sharedApplication().keyWindow {
            let view = HolyView(frame: window.bounds)
            view.alpha = 0
            view.backgroundColor = bgColor
            window.addSubview(view)
            
            view.completion = completion
            view.tapRec.addTarget(view, action: "holyViewTapped")
            view.addGestureRecognizer(view.tapRec)
            view.userInteractionEnabled = true
            
            view.holePosition = position
            view.holeRadius = radius
            
            //MASK
            
            let maskLayer = CAShapeLayer()
            var path = CGPathCreateMutable()
            
            CGPathAddArc(path, nil, position.x, position.y, radius, 0.0, 2*3.14, false)
            CGPathAddRect(path, nil, CGRectMake(0, 0, view.bounds.width, view.bounds.height))
            
            maskLayer.backgroundColor = UIColor.blackColor().CGColor
            maskLayer.path = path;
            maskLayer.fillRule = kCAFillRuleEvenOdd
            
            view.layer.mask = maskLayer
            view.clipsToBounds = true
            if let message = message {
                view.addMessage(message)
            }
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                view.alpha = 0.7
            })
        }
    }
    
    private func addMessage(message: String) {
        let addToTop: Bool = holePosition.y > (self.bounds.height/2)
        
        let container = UIView()
        container.setTranslatesAutoresizingMaskIntoConstraints(false)
        container.backgroundColor = UIColor.clearColor()
        addSubview(container)
        
        self.addConstraint(NSLayoutConstraint(item: container, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: container, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: container, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: (addToTop ? -(self.bounds.height-(holePosition.y-holeRadius)) : 0.0)))
        self.addConstraint(NSLayoutConstraint(item: container, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: (addToTop ? 0.0 : holePosition.y+holeRadius)))
        
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        container.addSubview(label)
        
        label.font = UIFont.systemFontOfSize(20.0)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.text = message
        
        container.addConstraint(NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: container, attribute: .Leading, multiplier: 1.0, constant: 16.0))
        container.addConstraint(NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: container, attribute: .Trailing, multiplier: 1.0, constant: -16.0))
        container.addConstraint(NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: container, attribute: .Top, multiplier: 1.0, constant: 16.0))
        
        let buttonLabel = UILabel()
        buttonLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        container.addSubview(buttonLabel)
        
        buttonLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
        buttonLabel.textColor = UIColor.whiteColor()
        buttonLabel.textAlignment = .Center
        buttonLabel.numberOfLines = 1
        buttonLabel.text = "GOT IT!"
        
        container.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Leading, relatedBy: .Equal, toItem: container, attribute: .Leading, multiplier: 1.0, constant: 16.0))
        container.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Trailing, relatedBy: .Equal, toItem: container, attribute: .Trailing, multiplier: 1.0, constant: -16.0))
        container.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Bottom, relatedBy: .Equal, toItem: container, attribute: .Bottom, multiplier: 1.0, constant: -16.0))
        container.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Top, relatedBy: .Equal, toItem: label, attribute: .Bottom, multiplier: 1.0, constant: 16.0))
        buttonLabel.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 44.0))
    }
    
    //MARK: - Actions
    
    @objc private func holyViewTapped() {
        if let c = completion {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.alpha = 0
            }, completion: { (complete: Bool) -> Void in
                self.removeFromSuperview()
                c(dismissed: true)
            })
        }
    }
    
    
    
    

}
