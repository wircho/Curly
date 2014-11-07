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
var CurlyAssociatedDelegateDictionaryHandle: UInt8 = 0
var CurlyAssociatedDeinitDelegateArrayHandle: UInt8 = 0

//MARK: Extensions

public extension UIAlertView {
    public func show(#clicked:(alertView:UIAlertView,buttonIndex:Int)->Void) {
        self.show(clicked:clicked,willPresent:nil, didPresent: nil, willDismiss: nil, didDismiss: nil, canceled: nil, shouldEnableFirstOtherButton: nil)
    }

    public func show(#willDismiss:(alertView:UIAlertView,buttonIndex:Int)->Void) {
        self.show(clicked:nil,willPresent:nil, didPresent: nil, willDismiss:willDismiss, didDismiss: nil, canceled: nil, shouldEnableFirstOtherButton: nil)
    }

    public func show(#didDismiss:(alertView:UIAlertView,buttonIndex:Int)->Void) {
        self.show(clicked:nil,willPresent:nil, didPresent: nil, willDismiss: nil, didDismiss: didDismiss, canceled: nil, shouldEnableFirstOtherButton: nil)
    }

    public func show(#clicked:((alertView:UIAlertView,buttonIndex:Int)->Void)?,
        willPresent:((alertView:UIAlertView)->Void)?,
        didPresent:((alertView:UIAlertView)->Void)?,
        willDismiss:((alertView:UIAlertView,buttonIndex:Int)->Void)?,
        didDismiss:((alertView:UIAlertView,buttonIndex:Int)->Void)?,
        canceled:((alertView:UIAlertView)->Void)?,
        shouldEnableFirstOtherButton:((alertView:UIAlertView)->Bool)?) {

            let delegate = Curly.AlertViewDelegate(clicked: clicked, willPresent: willPresent, didPresent: didPresent, willDismiss: willDismiss, didDismiss: didDismiss, canceled: canceled, shouldEnableFirstOtherButton: shouldEnableFirstOtherButton)

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
    convenience init<T:UIGestureRecognizer>(recognized:(T)->Void) {
        let delegate = CurlyGestureRecognizerDelegate(recognized: recognized)
        
        self.init(target: delegate, action: "recognizedGestureRecognizer:")
        
        
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }
}

public extension UIControl {
    
    //This method is only here because Objective-C is not able to access dynamic methods from Swift
    public func objc_addAction(events:UIControlEvents,closure:(UIControl)->Void)
    {
        self.addAction(events, closure: closure)
    }
    
    public func addAction<T:UIControl>(events:UIControlEvents,closure:(T)->Void) {

        var delegateDictionary = objc_getAssociatedObject(self, &CurlyAssociatedDelegateDictionaryHandle) as [UInt:[CurlyControlDelegate]]!

        if delegateDictionary == nil {
            delegateDictionary = [:]
        }

        if delegateDictionary[events.rawValue] == nil {
            delegateDictionary[events.rawValue] = []
        }

        let delegate = CurlyControlDelegate(received: closure)

        self.addTarget(delegate, action:Selector("recognizedControlEvent:"), forControlEvents: events)

        delegateDictionary[events.rawValue]!.append(delegate)

        objc_setAssociatedObject(self, &CurlyAssociatedDelegateDictionaryHandle, delegateDictionary, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))

    }

    public func removeActions(events:UIControlEvents) {

        var delegateDictionary = objc_getAssociatedObject(self, &CurlyAssociatedDelegateDictionaryHandle) as [UInt:AnyObject]!

        if delegateDictionary == nil {
            return
        }

        delegateDictionary[events.rawValue] = nil

        objc_setAssociatedObject(self, &CurlyAssociatedDelegateDictionaryHandle, delegateDictionary, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))

    }
}

public extension NSObject {
    
    public func deinited(closure:()->Void) {
        var deinitArray = objc_getAssociatedObject(self, &CurlyAssociatedDeinitDelegateArrayHandle) as [CurlyDeinitDelegate]!
        
        if deinitArray == nil {
            deinitArray = []
        }
        
        deinitArray.append(CurlyDeinitDelegate(deinited: closure))
        
        objc_setAssociatedObject(self, &CurlyAssociatedDeinitDelegateArrayHandle, deinitArray, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        
    }
    
    public func removeDeinitObservers() {
        var deinitArray = objc_getAssociatedObject(self, &CurlyAssociatedDeinitDelegateArrayHandle) as [CurlyDeinitDelegate]!
        
        if deinitArray == nil {
            return
        }
        
        for delegate in deinitArray {
            delegate.deinited = nil
        }
        
        objc_setAssociatedObject(self, &CurlyAssociatedDeinitDelegateArrayHandle, nil, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }
    
}

//MARK: Curly class

class Curly : NSObject {
    
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
    
    private class AlertViewDelegate: NSObject, UIAlertViewDelegate {

        var clicked:((alertView:UIAlertView,buttonIndex:Int)->Void)?
        var willPresent:((alertView:UIAlertView)->Void)?
        var didPresent:((alertView:UIAlertView)->Void)?
        var willDismiss:((alertView:UIAlertView,buttonIndex:Int)->Void)?
        var didDismiss:((alertView:UIAlertView,buttonIndex:Int)->Void)?
        var canceled:((alertView:UIAlertView)->Void)?
        var shouldEnableFirstOtherButton:((alertView:UIAlertView)->Bool)?

        init(clicked v_clicked:((alertView:UIAlertView,buttonIndex:Int)->Void)?,
            willPresent v_willPresent:((alertView:UIAlertView)->Void)?,
            didPresent v_didPresent:((alertView:UIAlertView)->Void)?,
            willDismiss v_willDismiss:((alertView:UIAlertView,buttonIndex:Int)->Void)?,
            didDismiss v_didDismiss:((alertView:UIAlertView,buttonIndex:Int)->Void)?,
            canceled v_canceled:((alertView:UIAlertView)->Void)?,
            shouldEnableFirstOtherButton v_shouldEnableFirstOtherButton:((alertView:UIAlertView)->Bool)?) {
                clicked = v_clicked
                willPresent = v_willPresent
                didPresent = v_didPresent
                willDismiss = v_willDismiss
                didDismiss = v_didDismiss
                canceled = v_canceled
                shouldEnableFirstOtherButton = v_shouldEnableFirstOtherButton
                super.init()
        }

        private func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
            if clicked != nil {
                clicked!(alertView: alertView,buttonIndex: buttonIndex)
            }
        }

        private func alertViewCancel(alertView: UIAlertView) {
            if canceled == nil {
                alertView.dismissWithClickedButtonIndex(alertView.cancelButtonIndex, animated: false)
            }else{
                canceled!(alertView:alertView)
            }
        }

        private func willPresentAlertView(alertView: UIAlertView) {
            if willPresent != nil {
                willPresent!(alertView: alertView)
            }
        }

        private func didPresentAlertView(alertView: UIAlertView) {
            if didPresent != nil {
                didPresent!(alertView: alertView)
            }
        }

        private func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int) {
            if willDismiss != nil {
                willDismiss!(alertView: alertView, buttonIndex: buttonIndex)
            }
        }

        private func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
            if didDismiss != nil {
                didDismiss!(alertView: alertView, buttonIndex: buttonIndex)
            }
        }
        
        private func alertViewShouldEnableFirstOtherButton(alertView: UIAlertView) -> Bool {
            if shouldEnableFirstOtherButton == nil {
                return true
            }else{
                return shouldEnableFirstOtherButton!(alertView: alertView)
            }
        }
    }
    
}

//MARK: Gesture recognizer delegate

public class CurlyGestureRecognizerDelegate: NSObject {
    
    let recognized:(UIGestureRecognizer)->Void
    
    public func recognizedGestureRecognizer(gr:UIGestureRecognizer) {
        recognized(gr)
    }
    
    init<T:UIGestureRecognizer>(recognized:(T)->Void) {
        self.recognized = { (gestureRecognizer:UIGestureRecognizer) -> Void in
            if let gr = gestureRecognizer as? T {
                recognized(gr)
            }
        }
        
        super.init()
    }
}

//MARK: UIControl delegate

public class CurlyControlDelegate: NSObject {
    
    public let received:(UIControl)->Void
    
    public func recognizedControlEvent(ctl:UIControl) {
        received(ctl)
    }
    
    init<T:UIControl>(received:(T)->Void) {
        self.received = { (control:UIControl) -> Void in
            if let ctl = control as? T {
                received(ctl)
            }
            
        }
        super.init()
    }
}

//MARK Deinit delegate

public class CurlyDeinitDelegate: NSObject {
    
    public var deinited:(()->Void)!
    
    deinit {
        if deinited != nil {
            deinited()
        }
    }
    
    init(deinited:()->Void) {
        self.deinited = deinited
        super.init()
    }
    
}

