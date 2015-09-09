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
        HolyView.show(UIColor.blackColor(), position: sender.center(), radius: 25, message: "Test message") { (dismissed) -> Void in
            
        }
    }
    
    @IBAction func rightBarButtonPressed(sender: AnyObject) {
        HolyView.show(UIColor.blackColor(), position: favoritesTabButton.center(), radius: 30.0, message: "There is no chances to fail!") { (dismissed) -> Void in
            
        }
    }

    @IBAction func topLeftButtonPressed(sender: UIButton) {
        HolyView.show(UIColor.blackColor(), position: sender.center, radius: 50.0, message: "") { (dismissed) -> Void in
            
        }
    }
    
    @IBAction func centerButtonPressed(sender: AnyObject) {
        HolyView.show(UIColor.blackColor(), position: sender.center, radius: 50.0, message: "") { (dismissed) -> Void in
            
        }
    }

}

