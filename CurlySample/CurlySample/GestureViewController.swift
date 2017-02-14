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

        
        let fingerView = UIView(frame: CGRect(x:0,y:0,width:50,height:50))
        fingerView.backgroundColor = UIColor.red
        fingerView.layer.cornerRadius = fingerView.frame.size.width/CGFloat(2)
        fingerView.isHidden = true
        
        self.view.addSubview(fingerView)
        
        self.view.addGestureRecognizer(
            UIPanGestureRecognizer {
                (panGR:UIPanGestureRecognizer)->Void in
                
                switch panGR.state {
                case .began:
                    fingerView.isHidden = false
                    fallthrough
                case .changed:
                    fingerView.center = panGR.location(in: panGR.view!)
                case .ended:
                    fallthrough
                case .failed:
                    fingerView.isHidden = true
                default:
                    break
                }
                
            }
        )
    
    }

}
