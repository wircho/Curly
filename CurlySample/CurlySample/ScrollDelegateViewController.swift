//
//  ScrollDelegateViewController.swift
//  CurlySample
//
//  Created by Adolfo Rodriguez on 2014-11-11.
//  Copyright (c) 2014 Wircho. All rights reserved.
//

import UIKit

class ScrollDelegateViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textView: UITextView!
    
    var strings: [(String,Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var s:ScrollDelegateViewController! = self
        
        scrollView.setDelegate(
            willBeginDragging: {
                (scrollView:UIScrollView) -> Void in
                s.appendText("will begin drag")
            },
            didScroll: { (scrollView:UIScrollView) -> Void in
                s.appendText("did scroll")
            },
            willEndDragging: { (scrollView:UIScrollView, withVelocity:CGPoint, targetContentOffset:UnsafeMutablePointer<CGPoint>) -> Void in
                s.appendText("will end drag")
            },
            didEndDragging: { (scrollView:UIScrollView, willDecelerate:Bool) -> Void in
                s.appendText("did end drag\n| (will"+(willDecelerate ? " " : " not ")+"decel.)")
            },
            willBeginDecelerating: { (scrollView:UIScrollView) -> Void in
                s.appendText("will begin decel.")
            },
            didEndDecelerating: { (scrollView:UIScrollView) -> Void in
                s.appendText("did end decel.")
            },
            didEndScrollingAnimation: { (scrollView:UIScrollView) -> Void in
                s.appendText("did end scroll anim.")
            },
            shouldScrollToTop:nil,
            didScrollToTop: { (scrollView:UIScrollView) -> Void in
                s.appendText("did scroll to top")
            },
            willBeginZooming:nil,
            didZoom:nil,
            didEndZooming:nil,
            viewForZooming:nil
        )
        
    }
    
    func appendText(string:String) {
        if strings.first?.0 == string {
            strings[0].1 += 1
        } else {
            strings.insert((string,1), atIndex: 0)
        }
        
        textView.text = strings.map{($1>1) ? "\($0) (\($1))" : $0}.joinWithSeparator("|      LOGS \n| (bottom to top)\n|\n| " + "\n|\n| ")
        
    }
    

}
