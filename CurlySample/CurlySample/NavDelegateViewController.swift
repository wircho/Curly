//
//  NavDelegateViewController.swift
//  CurlySample
//
//  Created by Adolfo Rodriguez on 2014-11-11.
//  Copyright (c) 2014 Wircho. All rights reserved.
//

import UIKit

class NavDelegateViewController: UIViewController {

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navController = segue.destinationViewController as! UINavigationController
        
        //Setting navigation controller delegate with closure
        
        navController.setDelegate(
            willShow: {
                [weak navController]
                (viewController:UIViewController, animated) in
                
                
                
                let index = (navController!.viewControllers as [UIViewController]).contains(viewController)
                    ? navController!.viewControllers.count - 1
                    : navController!.viewControllers.count
                
                //Setting title
                viewController.navigationItem.title = "View Controller #\(index+1)"
                
            },
            didShow: {
                [weak navController]
                (viewController:UIViewController, animated) in
                
                let index = (navController!.viewControllers as [UIViewController]).contains(viewController)
                    ? navController!.viewControllers.count - 1
                    : navController!.viewControllers.count
                
                switch index {
                    
                case 3: //Last
                    
                    break
                    
                case 0: //First
                    
                    //Adding left bar button item with closure
                    
                    viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done) {
                        [weak navController] in
                        
                        navController!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
                    }
                    
                    fallthrough
                    
                default:
                    
                    //Adding right bar button item with closure
                    
                    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain) {
                        [weak viewController] in
                        
                        viewController!.performSegueWithIdentifier("next", sender:nil)
                    }
                }
                
            }
        )
    }
    
    @IBAction func tappedPresent(sender: AnyObject) {
        
        //Performing segue with closure
        
        self.performSegueWithIdentifier("navigation", sender:nil)
        
    }
    
    
    

}
