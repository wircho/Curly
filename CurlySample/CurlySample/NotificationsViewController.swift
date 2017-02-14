//
//  NotificationsViewController.swift
//  CurlySample
//
//  Created by AdolfoX Rodriguez on 2016-06-01.
//  Copyright © 2016 Wircho. All rights reserved.
//

import UIKit

private let noteName = "TestNote"

class NotificationsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = noteName.observeFrom(self) {
            innerSelf,_ in
            
            innerSelf.timesFired += 1
        }
    }
    
    var timesFired:Int = 0 {
        didSet {
            if timesFired > 0 {
                label.text = "Notification fired \(timesFired) times"
            }
        }
    }
    
    @IBOutlet weak var label: UILabel!
    
    
    @IBAction func tappedFire(_ sender: Any) {
        NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: noteName), object: nil) as Notification)
    }
}
