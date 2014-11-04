//
//  AlertViewController.swift
//  CurlySample
//
//  Created by Adolfo Rodriguez on 2014-11-04.
//  Copyright (c) 2014 Wircho. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var buttonsField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func tappedShowButton(sender: AnyObject) {
        
        // This is just setup for the demo, no need to understand this part.
        // I'm simply creating a UIAlertView from the text fields' values.
        
        let alert = UIAlertView(title: (titleField.text == nil || titleField.text == "") ? "Title" : titleField.text, message: (messageField.text == nil || messageField.text == "") ? "Message" : messageField.text, delegate: nil, cancelButtonTitle: nil)
        
        var buttonTitles = ((buttonsField.text == nil || buttonsField.text == "") ? "OK" : buttonsField.text).componentsSeparatedByString(", ")
        var cancelTitle = buttonTitles.removeAtIndex(0)
        buttonTitles.append(cancelTitle)
        
        for title in buttonTitles {
            alert.addButtonWithTitle(title)
        }
        
        alert.cancelButtonIndex = buttonTitles.count - 1
        
        self.view.endEditing(true)
        
        // Here is the important part:
        
        alert.show(didDismiss:{(alertView:UIAlertView, buttonIndex:Int) -> Void in
            
            let text = alertView.buttonTitleAtIndex(buttonIndex)
            
            if buttonIndex == alertView.cancelButtonIndex {
                self.resultLabel.text = "Dismissed with cancel button: \"\(text)\""
            }else{
                self.resultLabel.text = "Dismissed with button: \"\(text)\""
            }
            
        })
        
    }
    
    
}
