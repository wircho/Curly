//
//  GestureViewController.swift
//  CurlySample
//
//  Created by Adolfo Rodriguez on 2014-11-05.
//  Copyright (c) 2014 Wircho. All rights reserved.
//

import UIKit

class GestureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        var fingerView = UIView(frame: CGRectMake(0,0,50,50))
        fingerView.backgroundColor = UIColor.redColor()
        fingerView.layer.cornerRadius = fingerView.frame.size.width/CGFloat(2)
        fingerView.hidden = true
        
        self.view.addSubview(fingerView)
        
        self.view.addGestureRecognizer(
            UIPanGestureRecognizer {
                (panGR:UIPanGestureRecognizer)->Void in
                
                switch panGR.state {
                case .Began:
                    fingerView.hidden = false
                    fallthrough
                case .Changed:
                    fingerView.center = panGR.locationInView(panGR.view!)
                case .Ended:
                    fallthrough
                case .Failed:
                    fingerView.hidden = true
                default:
                    break
                }
                
            }
        )
    
    }

}
