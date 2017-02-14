//
//  ControlViewController.swift
//  CurlySample
//
//  Created by Adolfo Rodriguez on 2014-11-06.
//  Copyright (c) 2014 Wircho. All rights reserved.
//

import UIKit

class ControlViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var weakSelf = self
        
        button.addAction(.touchUpInside) {
            (bttn:UIButton) -> Void in
            
            if let s = weakSelf {
                s.label.text = "Tapped button!"
            }
            
        }
        
        slider.addAction(.valueChanged) {
            (sdr:UISlider) -> Void in
            
            if let s = weakSelf {
                s.label.text = "Moved slider to value \(sdr.value)"
            }
        }
    }
    

}
