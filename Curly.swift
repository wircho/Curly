//
//  Curly.swift
//  Curly
//
//  Created by Adolfo Rodriguez on 2014-11-04.
//  Copyright (c) 2014 Wircho. All rights reserved.
//

import Foundation

import UIKit

//MARK: Constants

var CurlyAssociatedDelegateHandle: UInt8 = 0

//MARK: Extensions

public extension UIAlertView {
    public func show(#click:(alertView:UIAlertView,buttonIndex:Int)->Void) {
        self.show(click:click,willPresent:nil, didPresent: nil, willDismiss: nil, didDismiss: nil, cancel: nil, shouldEnableFirstOtherButton: nil)
    }

    public func show(#willDismiss:(alertView:UIAlertView,buttonIndex:Int)->Void) {
        self.show(click:nil,willPresent:nil, didPresent: nil, willDismiss:willDismiss, didDismiss: nil, cancel: nil, shouldEnableFirstOtherButton: nil)
    }

    public func show(#didDismiss:(alertView:UIAlertView,buttonIndex:Int)->Void) {
        self.show(click:nil,willPresent:nil, didPresent: nil, willDismiss: nil, didDismiss: didDismiss, cancel: nil, shouldEnableFirstOtherButton: nil)
    }

    public func show(#click:((alertView:UIAlertView,buttonIndex:Int)->Void)?,
        willPresent:((alertView:UIAlertView)->Void)?,
        didPresent:((alertView:UIAlertView)->Void)?,
        willDismiss:((alertView:UIAlertView,buttonIndex:Int)->Void)?,
        didDismiss:((alertView:UIAlertView,buttonIndex:Int)->Void)?,
        cancel:((alertView:UIAlertView)->Void)?,
        shouldEnableFirstOtherButton:((alertView:UIAlertView)->Bool)?) {

            let delegate = Curly.AlertViewDelegate(click: click, willPresent: willPresent, didPresent: didPresent, willDismiss: willDismiss, didDismiss: didDismiss, cancel: cancel, shouldEnableFirstOtherButton: shouldEnableFirstOtherButton)

            self.delegate = delegate
            
            objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))

            self.show()

    }
}

public extension UIViewController {
    
    
    public func performSegueWithIdentifier(identifier: String?, sender: AnyObject?, preparation:(UIStoryboardSegue,AnyObject?)->Void) {
        
        if let id = identifier {
            Curly.registerSeguePreparation(id, viewController: self, preparation: preparation)
            
            self.performSegueWithIdentifier(id, sender: sender)
            
        }
        
        
    }
    
    public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let id = segue.identifier {
            if let (index,preparation) = Curly.getSeguePreparation(id, viewController: self) {
                preparation(segue,sender)
                Curly.unregisterSeguePreparation(index)
            }
        }

    }
}

public extension UIGestureRecognizer {
    convenience init(recognized:(UIGestureRecognizer)->Void) {
        let delegate = Curly.GestureRecognizerDelegate(recognized:recognized)
        
        self.init(target: delegate, action: "recognizedGestureRecognizer:")
        
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }
}

//MARK: Curly class

public class Curly : NSObject {
    
//MARK: UIGestureRecognizer
    
    public class GestureRecognizerDelegate: NSObject {
        
        var recognized:(UIGestureRecognizer)->Void
        
        public func recognizedGestureRecognizer(gr:UIGestureRecognizer) {
            recognized(gr)
        }
        
        init(recognized:(UIGestureRecognizer)->Void) {
            self.recognized = recognized
            super.init()
        }
    }
    
//MARK: UIViewController, UIStoryboardSegue

    private struct SeguePreparation {
        let identifier:String
        let viewController:UIViewController
        let preparation:(UIStoryboardSegue,AnyObject?)->Void
        static var preparations:[SeguePreparation] = []
    }

    private class func registerSeguePreparation(identifier:String, viewController:UIViewController, preparation:(UIStoryboardSegue, AnyObject?) -> Void) {

        if let (index,_) = getSeguePreparation(identifier, viewController: viewController) {
            unregisterSeguePreparation(index)
        }
        
        SeguePreparation.preparations.append( SeguePreparation(identifier: identifier, viewController: viewController, preparation: preparation))
        
    }
    
    private class func unregisterSeguePreparation(index:Int) {
        
        SeguePreparation.preparations.removeAtIndex(index)
        
    }

    private class func getSeguePreparation(identifier:String, viewController:UIViewController) -> (Int,((UIStoryboardSegue, AnyObject?) -> Void))? {
        
        for var i = 0; i < SeguePreparation.preparations.count; i += 1 {
            let prep = SeguePreparation.preparations[i]
            if prep.identifier == identifier && prep.viewController == viewController {
                return (i,prep.preparation)
            }
        }
        
        return nil
        
    }

//MARK: UIAlertView, UIAlertViewDelegate
    
    public class AlertViewDelegate: NSObject, UIAlertViewDelegate {

        var click:((alertView:UIAlertView,buttonIndex:Int)->Void)?
        var willPresent:((alertView:UIAlertView)->Void)?
        var didPresent:((alertView:UIAlertView)->Void)?
        var willDismiss:((alertView:UIAlertView,buttonIndex:Int)->Void)?
        var didDismiss:((alertView:UIAlertView,buttonIndex:Int)->Void)?
        var cancel:((alertView:UIAlertView)->Void)?
        var shouldEnableFirstOtherButton:((alertView:UIAlertView)->Bool)?

        init(click v_click:((alertView:UIAlertView,buttonIndex:Int)->Void)?,
            willPresent v_willPresent:((alertView:UIAlertView)->Void)?,
            didPresent v_didPresent:((alertView:UIAlertView)->Void)?,
            willDismiss v_willDismiss:((alertView:UIAlertView,buttonIndex:Int)->Void)?,
            didDismiss v_didDismiss:((alertView:UIAlertView,buttonIndex:Int)->Void)?,
            cancel v_cancel:((alertView:UIAlertView)->Void)?,
            shouldEnableFirstOtherButton v_shouldEnableFirstOtherButton:((alertView:UIAlertView)->Bool)?) {
                click = v_click
                willPresent = v_willPresent
                didPresent = v_didPresent
                willDismiss = v_willDismiss
                didDismiss = v_didDismiss
                cancel = v_cancel
                shouldEnableFirstOtherButton = v_shouldEnableFirstOtherButton
                super.init()
        }

        public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
            if click != nil {
                click!(alertView: alertView,buttonIndex: buttonIndex)
            }
        }

        public func alertViewCancel(alertView: UIAlertView) {
            if cancel == nil {
                alertView.dismissWithClickedButtonIndex(alertView.cancelButtonIndex, animated: false)
            }else{
                cancel!(alertView:alertView)
            }
        }

        public func willPresentAlertView(alertView: UIAlertView) {
            if willPresent != nil {
                willPresent!(alertView: alertView)
            }
        }

        public func didPresentAlertView(alertView: UIAlertView) {
            if didPresent != nil {
                didPresent!(alertView: alertView)
            }
        }

        public func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int) {
            if willDismiss != nil {
                willDismiss!(alertView: alertView, buttonIndex: buttonIndex)
            }
        }

        public func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
            if didDismiss != nil {
                didDismiss!(alertView: alertView, buttonIndex: buttonIndex)
            }
        }
        
        public func alertViewShouldEnableFirstOtherButton(alertView: UIAlertView) -> Bool {
            if shouldEnableFirstOtherButton == nil {
                return false
            }else{
                return shouldEnableFirstOtherButton!(alertView: alertView)
            }
        }
    }
    
    
    
}