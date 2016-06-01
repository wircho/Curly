//
//  DeinitViewController.swift
//  CurlySample
//
//  Created by Adolfo Rodriguez on 2014-11-07.
//  Copyright (c) 2014 Wircho. All rights reserved.
//

import UIKit

class DeinitViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func tappedButton(sender: UIButton) {
        sender.removeFromSuperview()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var weakSelf = self
        
        button.deinited {
            
            if let lb = weakSelf?.label {
                lb.text = "Deinited button!"
            }
            
        }
        
    }
    
    

}
