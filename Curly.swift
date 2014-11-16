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
var CurlyAssociatedLayoutDelegateHandle: UInt8 = 0

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

public extension UINavigationController {
    public func setDelegate(#willShow:((viewController:UIViewController,animated:Bool)->Void)?, didShow:((viewController:UIViewController,animated:Bool)->Void)? = nil) {
        
        let delegate = Curly.NavigationControllerDelegate(willShow: willShow, didShow: didShow)
        
        self.delegate = delegate
        
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        
    }
}

public extension UIScrollView {
    
    public func setDelegate(
        #didScroll:((scrollView: UIScrollView) -> Void)?) {
            
            let delegate = Curly.ScrollViewDelegate(willBeginDragging:nil,didScroll:didScroll,willEndDragging:nil,didEndDragging:nil,willBeginDecelerating:nil,didEndDecelerating:nil,didEndScrollingAnimation:nil,shouldScrollToTop:nil,didScrollToTop:nil,willBeginZooming:nil,didZoom:nil,didEndZooming:nil,viewForZooming:nil)
            
            self.delegate = delegate
            
            objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            
    }
    
    public func setDelegate(
        #willBeginDragging:((scrollView: UIScrollView) -> Void)?,didScroll:((scrollView: UIScrollView) -> Void)?,willEndDragging:((scrollView: UIScrollView, withVelocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)?,didEndDragging:((scrollView: UIScrollView, willDecelerate: Bool) -> Void)?,willBeginDecelerating:((scrollView: UIScrollView) -> Void)?,didEndDecelerating:((scrollView: UIScrollView) -> Void)?,didEndScrollingAnimation:((scrollView: UIScrollView) -> Void)?,shouldScrollToTop:((scrollView: UIScrollView) -> Bool)?,didScrollToTop:((scrollView: UIScrollView) -> Void)?,willBeginZooming:((scrollView: UIScrollView, withView: UIView!) -> Void)?,didZoom:((scrollView: UIScrollView) -> Void)?,didEndZooming:((scrollView: UIScrollView, withView: UIView!, atScale: CGFloat) -> Void)?,viewForZooming:((scrollView:UIScrollView)->UIView?)?) {
        
        let delegate = Curly.ScrollViewDelegate(willBeginDragging:willBeginDragging,didScroll:didScroll,willEndDragging:willEndDragging,didEndDragging:didEndDragging,willBeginDecelerating:willBeginDecelerating,didEndDecelerating:didEndDecelerating,didEndScrollingAnimation:didEndScrollingAnimation,shouldScrollToTop:shouldScrollToTop,didScrollToTop:didScrollToTop,willBeginZooming:willBeginZooming,didZoom:didZoom,didEndZooming:didEndZooming,viewForZooming:viewForZooming)
        
        self.delegate = delegate
        
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        
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
    
    //Objective C support
    convenience init (block:(UIGestureRecognizer)->Void) {
        self.init(closure:block)
    }
    
    convenience init<T:UIGestureRecognizer>(closure:(T)->Void) {
        let delegate = Curly.GestureRecognizerDelegate(recognized: closure)
        
        self.init(target: delegate, action: "recognizedGestureRecognizer:")
        
        
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }
}

public extension UIBarButtonItem {
    convenience init(barButtonSystemItem: UIBarButtonSystemItem, closure:()->Void) {
        
        let delegate = Curly.BarButtonItemDelegate(tapped: closure)
        
        self.init(barButtonSystemItem: barButtonSystemItem, target:delegate, action:"tappedButtonItem")
        
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }
    
    convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItemStyle, closure:()->Void) {
        
        let delegate = Curly.BarButtonItemDelegate(tapped: closure)
        
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target:delegate, action:"tappedButtonItem")
        
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        
    }
    
    convenience init(image: UIImage?, style: UIBarButtonItemStyle, closure:()->Void) {
        
        let delegate = Curly.BarButtonItemDelegate(tapped: closure)
        
        self.init(image: image, style: style, target:delegate, action:"tappedButtonItem")
        
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        
    }
    
    convenience init(title: String?, style: UIBarButtonItemStyle, closure:()->Void) {
        
        let delegate = Curly.BarButtonItemDelegate(tapped: closure)
        
        self.init(title: title, style: style, target:delegate, action:"tappedButtonItem")
        
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        
    }
}

public extension UIControl {
    
    //Objective C support
    public func addAction(events:UIControlEvents,block:(UIControl)->Void)
    {
        self.addAction(events, closure: block)
    }
    
    public func addAction<T:UIControl>(events:UIControlEvents,closure:(T)->Void) {

        var delegateDictionary = objc_getAssociatedObject(self, &CurlyAssociatedDelegateDictionaryHandle) as [UInt:[Curly.ControlDelegate]]!

        if delegateDictionary == nil {
            delegateDictionary = [:]
        }

        if delegateDictionary[events.rawValue] == nil {
            delegateDictionary[events.rawValue] = []
        }

        let delegate = Curly.ControlDelegate(received: closure)

        self.addTarget(delegate, action:Selector("recognizedControlEvent:"), forControlEvents: events)

        delegateDictionary[events.rawValue]!.append(delegate)

        objc_setAssociatedObject(self, &CurlyAssociatedDelegateDictionaryHandle, delegateDictionary, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))

    }

    public func removeActions(events:UIControlEvents) {
        
        var delegateDictionary = objc_getAssociatedObject(self, &CurlyAssociatedDelegateDictionaryHandle) as [UInt:[Curly.ControlDelegate]]!

        if delegateDictionary == nil {
            return
        }

        if let array = delegateDictionary[events.rawValue] {
            for delegate in array {
                self.removeTarget(delegate, action: "recognizedControlEvent:", forControlEvents: events)
            }
        }
        
        delegateDictionary[events.rawValue] = nil

        objc_setAssociatedObject(self, &CurlyAssociatedDelegateDictionaryHandle, delegateDictionary, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))

    }
}

public extension NSObject {
    
    public func deinited(closure:()->Void) {
        var deinitArray = objc_getAssociatedObject(self, &CurlyAssociatedDeinitDelegateArrayHandle) as [Curly.DeinitDelegate]!
        
        if deinitArray == nil {
            deinitArray = []
        }
        
        deinitArray.append(Curly.DeinitDelegate(deinited: closure))
        
        objc_setAssociatedObject(self, &CurlyAssociatedDeinitDelegateArrayHandle, deinitArray, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        
    }
    
    public func removeDeinitObservers() {
        var deinitArray = objc_getAssociatedObject(self, &CurlyAssociatedDeinitDelegateArrayHandle) as [Curly.DeinitDelegate]!
        
        if deinitArray == nil {
            return
        }
        
        for delegate in deinitArray {
            delegate.deinited = nil
        }
        
        objc_setAssociatedObject(self, &CurlyAssociatedDeinitDelegateArrayHandle, nil, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }
    
}

public extension UIView {
    
    public func layoutSubviews() {
        let layoutDelegate = objc_getAssociatedObject(self,&CurlyAssociatedLayoutDelegateHandle) as Curly.LayoutDelegate?
        
        layoutDelegate?.layout(self)
    }
    
    public func layout<T:UIView>(closure:(T)->Void) {
        
        let layoutDelegate = Curly.LayoutDelegate(closure:closure)
        
        objc_setAssociatedObject(self, &CurlyAssociatedLayoutDelegateHandle,layoutDelegate, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        
    }
    
}

//MARK: Curly class

public class Curly : NSObject {
    
    //MARK: Performing actions with delay
    
    private struct Delay {
        static var delayKeys:[String:Int] = [:]
        static var delayCounter:Int = 0
    }
    
    class func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    class func delay(delay:Double,key:String,closure:()->()) {
        Delay.delayCounter += 1
        var counter = Delay.delayCounter
        Delay.delayKeys[key] = counter
        
        self.delay(delay) {
            if let value = self.Delay.delayKeys[key] {
                if value == counter {
                    closure()
                    self.stopDelay(key)
                }
            }
        }
    }
    
    class func stopDelay(key:String) {
        Delay.delayKeys[key] = nil
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

    //MARK: UIScrollView, UIScrolViewDelegate
    
    private class ScrollViewDelegate: NSObject, UIScrollViewDelegate {
        
        var willBeginDragging:((scrollView: UIScrollView) -> Void)?
        var didScroll:((scrollView: UIScrollView) -> Void)?
        var willEndDragging:((scrollView: UIScrollView, withVelocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)?
        var didEndDragging:((scrollView: UIScrollView, willDecelerate: Bool) -> Void)?
        var willBeginDecelerating:((scrollView: UIScrollView) -> Void)?
        var didEndDecelerating:((scrollView: UIScrollView) -> Void)?
        var didEndScrollingAnimation:((scrollView: UIScrollView) -> Void)?
        var shouldScrollToTop:((scrollView: UIScrollView) -> Bool)?
        var didScrollToTop:((scrollView: UIScrollView) -> Void)?
        var willBeginZooming:((scrollView: UIScrollView, withView: UIView!) -> Void)?
        var didZoom:((scrollView: UIScrollView) -> Void)?
        var didEndZooming:((scrollView: UIScrollView, withView: UIView!, atScale: CGFloat) -> Void)?
        var viewForZooming:((scrollView:UIScrollView)->UIView?)?
        
        init(willBeginDragging:((scrollView: UIScrollView) -> Void)?,didScroll:((scrollView: UIScrollView) -> Void)?,willEndDragging:((scrollView: UIScrollView, withVelocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)?,didEndDragging:((scrollView: UIScrollView, willDecelerate: Bool) -> Void)?,willBeginDecelerating:((scrollView: UIScrollView) -> Void)?,didEndDecelerating:((scrollView: UIScrollView) -> Void)?,didEndScrollingAnimation:((scrollView: UIScrollView) -> Void)?,shouldScrollToTop:((scrollView: UIScrollView) -> Bool)?,didScrollToTop:((scrollView: UIScrollView) -> Void)?,willBeginZooming:((scrollView: UIScrollView, withView: UIView!) -> Void)?,didZoom:((scrollView: UIScrollView) -> Void)?,didEndZooming:((scrollView: UIScrollView, withView: UIView!, atScale: CGFloat) -> Void)?,viewForZooming:((scrollView:UIScrollView)->UIView?)?){
            
            self.willBeginDragging = willBeginDragging
            self.didScroll = didScroll
            self.willEndDragging = willEndDragging
            self.didEndDragging = didEndDragging
            self.willBeginDecelerating = willBeginDecelerating
            self.didEndDecelerating = didEndDecelerating
            self.didEndScrollingAnimation = didEndScrollingAnimation
            self.shouldScrollToTop = shouldScrollToTop
            self.didScrollToTop = didScrollToTop
            self.willBeginZooming = willBeginZooming
            self.didZoom = didZoom
            self.didEndZooming = didEndZooming
            self.viewForZooming = viewForZooming
            super.init()
        }
        
        private func scrollViewWillBeginDragging(scrollView: UIScrollView) {
            willBeginDragging?(scrollView:scrollView)
        }
        private func scrollViewDidScroll(scrollView: UIScrollView) {
            didScroll?(scrollView:scrollView)
        }
        private func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            willEndDragging?(scrollView:scrollView,withVelocity:velocity,targetContentOffset:targetContentOffset)
        }
        private func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            didEndDragging?(scrollView:scrollView,willDecelerate:decelerate)
        }
        private func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
            willBeginDecelerating?(scrollView:scrollView)
        }
        private func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
            didEndDecelerating?(scrollView:scrollView)
        }
        private func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
            didEndScrollingAnimation?(scrollView:scrollView)
        }
        private func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
            if let b = shouldScrollToTop?(scrollView: scrollView) {
                return b
            }else{
                return true
            }
        }
        private func scrollViewDidScrollToTop(scrollView: UIScrollView) {
            didScrollToTop?(scrollView: scrollView)
        }
        private func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
            willBeginZooming?(scrollView:scrollView,withView:view)
        }
        private func scrollViewDidZoom(scrollView: UIScrollView) {
            didZoom?(scrollView:scrollView)
        }
        private func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
            didEndZooming?(scrollView:scrollView,withView:view,atScale:scale)
        }
        private func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
            return viewForZooming?(scrollView: scrollView)
        }

    }
    
    
    //MARK: UINavigationController, UINavigationControllerDelegate
    
    private class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
        
        var willShow:((viewController:UIViewController,animated:Bool)->Void)?
        var didShow:((viewController:UIViewController,animated:Bool)->Void)?
        
        init(willShow v_willShow:((viewController:UIViewController,animated:Bool)->Void)?, didShow v_didShow:((viewController:UIViewController,animated:Bool)->Void)?) {
            self.willShow = v_willShow
            self.didShow = v_didShow
            super.init()
        }
        
        private func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
            if willShow != nil {
                willShow!(viewController: viewController, animated: animated);
            }
        }
        
        private func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
            if didShow != nil {
                didShow!(viewController: viewController, animated: animated);
            }
        }
        
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
    
    //MARK: Bar button item delegate
    
    public class BarButtonItemDelegate: NSObject {
        let tapped:()->Void
        
        public func tappedButtonItem() {
            tapped()
        }
        
        init(tapped:()->Void) {
            self.tapped = tapped
            super.init()
        }
    }
    
    //MARK: Gesture recognizer delegate
    
    public class GestureRecognizerDelegate: NSObject {
        
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
    
    public class ControlDelegate: NSObject {
        
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
    
    //MARK: UIView layout delegate
    
    public class LayoutDelegate: NSObject {
        public let closure:(UIView)->Void
        
        func layout(v:UIView) {
            closure(v)
        }
        
        init<T:UIView>(closure:(T)->Void) {
            self.closure = {
                closure($0 as T)
            }
            super.init()
        }
    }
    
    //MARK: Deinit delegate
    
    public class DeinitDelegate: NSObject {
        
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
    
}



