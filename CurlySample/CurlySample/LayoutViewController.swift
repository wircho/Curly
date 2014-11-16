//
//  LayoutViewController.swift
//  CurlySample
//
//  Created by Adolfo Rodriguez on 2014-11-14.
//  Copyright (c) 2014 Wircho. All rights reserved.
//

import UIKit

class LayoutViewController: UIViewController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This is just to prevent the "swipe back" gesture on this VC
        //and to restore this setting at the end
        
        self.navigationController!.interactivePopGestureRecognizer.delegate = self
        weak var navVC:UINavigationController! = self.navigationController
        
        self.deinited {
            if let nvc = navVC {
                nvc.interactivePopGestureRecognizer.delegate = nil
            }
        }
        
        //Creating the blue view and the labels
        
        let redView = UIView(frame: CGRectMake(10,10,self.view.bounds.size.width-20,self.view.bounds.size.height-20))
        redView.backgroundColor = UIColor.redColor()
        redView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        let blueView = UIView()
        blueView.backgroundColor = UIColor.blueColor()
        
        let label = UILabel(frame:redView.bounds)
        label.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        label.font = UIFont(name: "HelveticaNeue-Regular", size: 20)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.text = "Move and resize the red view. The blue view will remain a square fitted in the red view"
        label.numberOfLines = 0
        
        redView.addSubview(blueView)
        redView.addSubview(label)
        self.view.addSubview(redView)
        
        //Layout with closure
        
        redView.layout {(v:UIView)->Void in
            
            let width = min(v.bounds.size.width,v.bounds.size.height)
            let height = width
            
            blueView.frame = CGRectMake((v.bounds.size.width - width)/CGFloat(2), (v.bounds.size.height - height)/CGFloat(2), width, height)
            
        }
        
        //Gesture recognizers to allow red view to be resized and moved
        
        enum Corner {
            case None
            case TopLeft
            case TopRight
            case BottomLeft
            case BottomRight
            case Center
        }
        
        var initialRect = CGRectZero
        var initialCorner = Corner.Center
        
        redView.addGestureRecognizer(
            UIPanGestureRecognizer {
                (gr:UIPanGestureRecognizer)->Void in
                
                let rv:UIView! = gr.view
                
                if rv == nil {
                    return
                }
                
                switch gr.state {
                case .Began:
                    initialRect = rv.frame
                    var point = gr.locationInView(rv)
                    
                    let width3 = rv.bounds.size.width/CGFloat(3)
                    let height3 = rv.bounds.size.height/CGFloat(3)
                    
                    if point.x < width3 && point.y < height3 {
                        initialCorner = .TopLeft
                    }else if point.x < width3 && point.y > 2*height3 {
                        initialCorner = .BottomLeft
                    }else if point.x > 2*width3 && point.y < height3 {
                        initialCorner = .TopRight
                    }else if point.x > 2*width3 && point.y > 2*height3 {
                        initialCorner = .BottomRight
                    }else {
                        initialCorner = .Center
                    }
                    
                case .Changed:
                    
                    var trans = gr.translationInView(rv.superview!)
                    var rect = initialRect
                    
                    switch initialCorner {
                    case .Center:
                        rect.origin.x += trans.x
                        rect.origin.y += trans.y
                    case .TopLeft:
                        rect.origin.x += trans.x
                        rect.origin.y += trans.y
                        rect.size.width -= trans.x
                        rect.size.height -= trans.y
                    case .TopRight:
                        rect.origin.y += trans.y
                        rect.size.width += trans.x
                        rect.size.height -= trans.y
                    case .BottomLeft:
                        rect.origin.x += trans.x
                        rect.size.width -= trans.x
                        rect.size.height += trans.y
                    case .BottomRight:
                        rect.size.width += trans.x
                        rect.size.height += trans.y
                    default:
                        break
                        
                    }
                    
                    rv.frame = rect
                    
                default:
                    initialCorner = .None
                }
            
            }
        )
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return false
    }

}
