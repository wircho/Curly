//
//  NavDelegateViewController.swift
//  CurlySample
//
//  Created by Adolfo Rodriguez on 2014-11-11.
//  Copyright (c) 2014 Wircho. All rights reserved.
//

import UIKit

class NavDelegateViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        
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
                    
                    viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.done) {
                        [weak navController] in
                        
                        navController!.presentingViewController!.dismiss(animated: true, completion: nil)
                    }
                    
                    fallthrough
                    
                default:
                    
                    //Adding right bar button item with closure
                    
                    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain) {
                        [weak viewController] in
                        
                        viewController!.performSegue(withIdentifier: "next", sender:nil)
                    }
                }
                
            }
        )
    }
    
    @IBAction func tappedPresent(_ sender: Any) {
        //Performing segue with closure
        
        self.performSegue(withIdentifier: "navigation", sender:nil)
    }
    
    
    
    

}
