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
    private var holeSize: CGSize = CGSizeZero {
        didSet {
            holeRadius = max(holeSize.height/2, holeSize.width/2)
        }
    }
    private var bgView = UIView()
    
    //MARK: - Public
    
    /// Custom view with transparent circle/rounded rectangle hole and title/button subview
    /// - Parameter bgColor: color for semi transparent background
    /// - Parameter center: center position of rounded rectangle
    /// - Parameter size: widht and height of rectangle (for circle radius using half of width)
    /// - Parameter cornerRadius: (Optional) using for rectangle corner radius (set nil for circle)
    /// - Parameter message: (Optional) message for view description
    /// - Parameter completion: completion block for touch recognizer
    
    class func show(withColor bgColor: UIColor, center: CGPoint, size: CGSize, cornerRadius: CGSize?, message: String?, completion: CompletionBlock) {
        
        let path = CGPathCreateMutable()
        if let cr = cornerRadius {
            CGPathAddRoundedRect(path, nil, CGRect(x: center.x-size.width/2, y: center.y-size.height/2, width: size.width, height: size.height), cr.width, cr.height)
        } else {
            CGPathAddArc(path, nil, center.x, center.y, size.width/2, 0.0, 2*3.14, false)
        }
        
        let view = HolyView()
        view.completion = completion
        view.holePosition = center
        view.holeSize = size
        
        view.setup(withColor: bgColor, holePath: path, message: message)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            view.bgView.alpha = 0.7
        })
    }
    
    //MARK: - Private
    
    private func setup(withColor bgColor: UIColor, holePath: CGMutablePathRef, message: String?) {
        if let window = UIApplication.sharedApplication().keyWindow {
            self.frame = window.bounds
            self.backgroundColor = UIColor.clearColor()
            window.addSubview(self)
            
            self.tapRec.addTarget(self, action: "holyViewTapped")
            self.addGestureRecognizer(self.tapRec)
            self.userInteractionEnabled = true
            
            //MASK
            
            self.bgView.backgroundColor = bgColor
            self.bgView.frame = self.bounds
            self.bgView.alpha = 0.0
            self.addSubview(self.bgView)
            
            let maskLayer = CAShapeLayer()
            
            CGPathAddRect(holePath, nil, CGRectMake(0, 0, self.bgView.bounds.width, self.bgView.bounds.height))
            maskLayer.backgroundColor = UIColor.blackColor().CGColor
            maskLayer.path = holePath;
            maskLayer.fillRule = kCAFillRuleEvenOdd
            
            self.bgView.layer.mask = maskLayer
            self.bgView.clipsToBounds = true
            if let message = message {
                self.addMessage(message)
            }
        }
    }
    
    private func addMessage(message: String) {
        let addToTop: Bool = holePosition.y > (self.bounds.height/2)
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.clearColor()
        addSubview(container)
        
        self.addConstraint(NSLayoutConstraint(item: container, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: container, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: container, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: (addToTop ? -(self.bounds.height-(holePosition.y-holeRadius)) : 0.0)))
        self.addConstraint(NSLayoutConstraint(item: container, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: (addToTop ? 0.0 : holePosition.y+holeRadius)))
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
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
                for v in self.subviews {
                    v.alpha = 0
                }
            }, completion: { (complete: Bool) -> Void in
                self.removeFromSuperview()
                c(dismissed: true)
            })
        }
    }
}

//MARK: - Extensions

extension UIBarItem {
    func center() -> CGPoint {
        if let view = self.valueForKey("view") as? UIView {
            if let superView = view.superview {
                return CGPoint(
                    x: superView.frame.origin.x + view.frame.origin.x + view.bounds.width/2,
                    y: superView.frame.origin.y + view.frame.origin.y + view.bounds.height/2
                )
            }
        }
        return CGPointZero
    }
}



