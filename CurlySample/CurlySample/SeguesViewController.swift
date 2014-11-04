//
//  SeguesViewController.swift
//  CurlySample
//
//  Created by Adolfo Rodriguez on 2014-11-04.
//  Copyright (c) 2014 Wircho. All rights reserved.
//

import UIKit

class SeguesViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    
    
    @IBAction func tappedPeformButton(sender: AnyObject) {
        
        // Perform segue with preparation closure (block)
        
        self.performSegueWithIdentifier("segue", sender: self) {
            (segue:UIStoryboardSegue, sender:AnyObject?) -> Void in
            
            let title = (self.titleField.text == nil || self.titleField.text == "") ? "Title" : self.titleField.text
            
            (segue.destinationViewController as UIViewController).navigationItem.title = title
            
        }
        
    }
    
    

}
