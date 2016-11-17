//
//  HolyView.swift
//  HolyView
//
//  Created by ruslanas on 9/2/15.
//  Copyright (c) 2015 Ruslanas Kudriavcevas. All rights reserved.
//

import UIKit

class HolyView: UIView {
  
  typealias CompletionBlock = (_ dismissed: Bool) -> Void
  fileprivate var completion: CompletionBlock?
  
  fileprivate let tapRec = UITapGestureRecognizer()
  fileprivate var holePosition = CGPoint.zero
  fileprivate var holeRadius: CGFloat = 0.0
  fileprivate var holeSize: CGSize = CGSize.zero {
    didSet {
      holeRadius = max(holeSize.height/2, holeSize.width/2)
    }
  }
  fileprivate var bgView = UIView()
  
  //MARK: - Public
  
  /// Custom view with transparent circle/rounded rectangle hole and title/button subview
  /// - Parameter bgColor: color for semi transparent background
  /// - Parameter center: center position of rounded rectangle
  /// - Parameter size: widht and height of rectangle (for circle radius using half of width)
  /// - Parameter cornerRadius: (Optional) using for rectangle corner radius (set nil for circle)
  /// - Parameter message: (Optional) message for view description
  /// - Parameter completion: completion block for touch recognizer
  
  class func show(withColor bgColor: UIColor, center: CGPoint, size: CGSize, cornerRadius: CGSize?, message: String?, completion: @escaping CompletionBlock) {
    
    let path = CGMutablePath()
    if let cr = cornerRadius {
      path.__addRoundedRect(transform: nil, rect: CGRect(x: center.x-size.width/2, y: center.y-size.height/2, width: size.width, height: size.height), cornerWidth: cr.width, cornerHeight: cr.height)
    } else {
      path.addArc(center: CGPoint.init(x: center.x, y: center.y), radius: size.width/2, startAngle: 0.0, endAngle: 2*3.14, clockwise: false)
    }
    
    let view = HolyView()
    view.completion = completion
    view.holePosition = center
    view.holeSize = size
    
    view.setup(withColor: bgColor, holePath: path, message: message)
    
    UIView.animate(withDuration: 0.3, animations: { () -> Void in
      view.bgView.alpha = 0.7
    })
  }
  
  //MARK: - Private
  
  fileprivate func setup(withColor bgColor: UIColor, holePath: CGMutablePath, message: String?) {
    if let window = UIApplication.shared.keyWindow {
      self.frame = window.bounds
      self.backgroundColor = UIColor.clear
      window.addSubview(self)
      
      self.tapRec.addTarget(self, action: #selector(HolyView.holyViewTapped))
      self.addGestureRecognizer(self.tapRec)
      self.isUserInteractionEnabled = true
      
      //MASK
      
      self.bgView.backgroundColor = bgColor
      self.bgView.frame = self.bounds
      self.bgView.alpha = 0.0
      self.addSubview(self.bgView)
      
      let maskLayer = CAShapeLayer()
      
      holePath.addRect(CGRect(x: 0, y: 0, width: self.bgView.bounds.width, height: self.bgView.bounds.height))
      maskLayer.backgroundColor = UIColor.black.cgColor
      maskLayer.path = holePath;
      maskLayer.fillRule = kCAFillRuleEvenOdd
      
      self.bgView.layer.mask = maskLayer
      self.bgView.clipsToBounds = true
      if let message = message {
        self.addMessage(message)
      }
    }
  }
  
  fileprivate func addMessage(_ message: String) {
    let addToTop: Bool = holePosition.y > (self.bounds.height/2)
    
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false
    container.backgroundColor = UIColor.clear
    addSubview(container)
    
    self.addConstraint(NSLayoutConstraint(item: container, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
    self.addConstraint(NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
    self.addConstraint(NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: (addToTop ? -(self.bounds.height-(holePosition.y-holeRadius)) : 0.0)))
    self.addConstraint(NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: (addToTop ? 0.0 : holePosition.y+holeRadius)))
    
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    container.addSubview(label)
    
    label.font = UIFont.systemFont(ofSize: 20.0)
    label.textColor = UIColor.white
    label.textAlignment = .center
    label.numberOfLines = 0
    label.text = message
    
    container.addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 16.0))
    container.addConstraint(NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: -16.0))
    container.addConstraint(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 16.0))
    
    let buttonLabel = UILabel()
    buttonLabel.translatesAutoresizingMaskIntoConstraints = false
    container.addSubview(buttonLabel)
    
    buttonLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
    buttonLabel.textColor = UIColor.white
    buttonLabel.textAlignment = .center
    buttonLabel.numberOfLines = 1
    buttonLabel.text = "GOT IT!"
    
    container.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 16.0))
    container.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: -16.0))
    container.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: -16.0))
    container.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .top, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1.0, constant: 16.0))
    buttonLabel.addConstraint(NSLayoutConstraint(item: buttonLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 44.0))
  }
  
  //MARK: - Actions
  
  @objc fileprivate func holyViewTapped() {
    if let c = completion {
      UIView.animate(withDuration: 0.3, animations: { () -> Void in
        for v in self.subviews {
          v.alpha = 0
        }
      }, completion: { (complete: Bool) -> Void in
        self.removeFromSuperview()
        c(true)
      })
    }
  }
}

//MARK: - Extensions

extension UIBarItem {
  func center() -> CGPoint {
    if let view = self.value(forKey: "view") as? UIView {
      if let superView = view.superview {
        return CGPoint(
          x: superView.frame.origin.x + view.frame.origin.x + view.bounds.width/2,
          y: superView.frame.origin.y + view.frame.origin.y + view.bounds.height/2
        )
      }
    }
    return CGPoint.zero
  }
}



