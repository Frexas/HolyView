//
//  ViewController.swift
//  HolyView
//
//  Created by ruslanas on 9/2/15.
//  Copyright (c) 2015 Ruslanas Kudriavcevas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var favoritesTabButton: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Actions
    
    @IBAction func leftBarButtonPressed(sender: UIBarButtonItem) {
        HolyView.show(withColor: UIColor.blackColor(), center: sender.center(), size: CGSize(width: 50.0, height: 50.0), cornerRadius: nil, message: "Test message") { (dismissed) -> Void in
            
        }
    }
    
    @IBAction func rightBarButtonPressed(sender: AnyObject) {
        HolyView.show(withColor: UIColor.blackColor(), center: favoritesTabButton.center(), size: CGSize(width: 60.0, height: 60.0), cornerRadius: nil, message: "There is no chances to fail!") { (dismissed) -> Void in
            
        }
    }

    @IBAction func topLeftButtonPressed(sender: UIButton) {
        HolyView.show(withColor: UIColor.blackColor(), center: sender.center, size: CGSize(width: 100.0, height: 100.0), cornerRadius: nil, message: "") { (dismissed) -> Void in
            
        }
    }
    
    @IBAction func centerButtonPressed(sender: AnyObject) {
        HolyView.show(withColor: UIColor.redColor(), center: sender.center, size: CGSize(width: 100.0, height: 60.0), cornerRadius: CGSizeZero, message: "Try to stop me!") { (dismissed) -> Void in
            HolyView.show(withColor: UIColor.redColor(), center: sender.center, size: CGSize(width: 100.0, height: 60.0), cornerRadius: CGSize(width: 4.0, height: 4.0), message: "Rounded corners") { (dismissed) -> Void in
                
            }
        }
    }

}

