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

private var CurlyAssociatedDelegateHandle: UInt8 = 0
private var CurlyAssociatedDelegateDictionaryHandle: UInt8 = 0
private var CurlyAssociatedDeinitDelegateArrayHandle: UInt8 = 0
private var CurlyAssociatedLayoutDelegateHandle: UInt8 = 0
private var CurlyAssociatedConnectionDelegateHandle: UInt8 = 0

//MARK: NSNotification Token Helper Class

open class CurlyNotificationToken {
    
    fileprivate weak var listener:AnyObject?
    fileprivate var observer:NSObjectProtocol!
    
    fileprivate init(listener:AnyObject, observer:NSObjectProtocol) {
        self.listener = listener
        self.observer = observer
    }
    
    deinit {
        self.cancel()
    }
    
    func cancel() {
        guard let observer = observer else { return }
        self.observer = nil
        NotificationCenter.default.removeObserver(observer)
    }
}

//MARK: Extensions

public extension String {
    func observeFrom<T:AnyObject>(_ listener:T,object:AnyObject? = nil,closure:@escaping (T,Notification)->Void) -> CurlyNotificationToken {
        var token:CurlyNotificationToken? = nil
        let observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: self), object: object, queue: nil) {
            note in
            guard let actualToken = token else { return }
            guard let listener = actualToken.listener as? T else {
                actualToken.cancel()
                token = nil
                return
            }
            closure(listener,note)
        }
        token = CurlyNotificationToken(listener: listener, observer: observer)
        (listener as? NSObject)?.deinited {
            [weak token] in
            token?.cancel()
        }
        return token!
    }
}

public extension UINavigationController {
    
    func setDelegate(willShow:((_ viewController:UIViewController,_ animated:Bool)->Void)?, didShow:((_ viewController:UIViewController,_ animated:Bool)->Void)? = nil) {
        
        let delegate = Curly.NavigationControllerDelegate(willShow: willShow, didShow: didShow)
        self.delegate = delegate
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
}

public extension UIScrollView {
    
    func setDelegate(
        didScroll:((_ scrollView: UIScrollView) -> Void)?) {
            
            let delegate = Curly.ScrollViewDelegate(willBeginDragging:nil,didScroll:didScroll,willEndDragging:nil,didEndDragging:nil,willBeginDecelerating:nil,didEndDecelerating:nil,didEndScrollingAnimation:nil,shouldScrollToTop:nil,didScrollToTop:nil,willBeginZooming:nil,didZoom:nil,didEndZooming:nil,viewForZooming:nil)
            self.delegate = delegate
            objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
    }
    
    func setDelegate(
        willBeginDragging:((_ scrollView: UIScrollView) -> Void)?,didScroll:((_ scrollView: UIScrollView) -> Void)?,willEndDragging:((_ scrollView: UIScrollView, _ withVelocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)?,didEndDragging:((_ scrollView: UIScrollView, _ willDecelerate: Bool) -> Void)?,willBeginDecelerating:((_ scrollView: UIScrollView) -> Void)?,didEndDecelerating:((_ scrollView: UIScrollView) -> Void)?,didEndScrollingAnimation:((_ scrollView: UIScrollView) -> Void)?,shouldScrollToTop:((_ scrollView: UIScrollView) -> Bool)?,didScrollToTop:((_ scrollView: UIScrollView) -> Void)?,willBeginZooming:((_ scrollView: UIScrollView, _ withView: UIView?) -> Void)?,didZoom:((_ scrollView: UIScrollView) -> Void)?,didEndZooming:((_ scrollView: UIScrollView, _ withView: UIView?, _ atScale: CGFloat) -> Void)?,viewForZooming:((_ scrollView:UIScrollView)->UIView?)?) {
            
            let delegate = Curly.ScrollViewDelegate(willBeginDragging:willBeginDragging,didScroll:didScroll,willEndDragging:willEndDragging,didEndDragging:didEndDragging,willBeginDecelerating:willBeginDecelerating,didEndDecelerating:didEndDecelerating,didEndScrollingAnimation:didEndScrollingAnimation,shouldScrollToTop:shouldScrollToTop,didScrollToTop:didScrollToTop,willBeginZooming:willBeginZooming,didZoom:didZoom,didEndZooming:didEndZooming,viewForZooming:viewForZooming)
            self.delegate = delegate
            objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
    }
}

public extension UIGestureRecognizer {
    
    //Objective-C Support
    convenience init (block: @escaping (UIGestureRecognizer)->Void) {
        self.init(closure:block)
    }
    
    convenience init<T:UIGestureRecognizer>(closure: @escaping (T)->Void) {
        let delegate = Curly.GestureRecognizerDelegate.init(recognized: closure)
        self.init(target: delegate, action: #selector(Curly.GestureRecognizerDelegate.recognizedGestureRecognizer(_:)))
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

public extension UIBarButtonItem {
    
    convenience init(barButtonSystemItem: UIBarButtonSystemItem, closure: @escaping ()->Void) {
        let delegate = Curly.BarButtonItemDelegate.init(tapped: closure)
        self.init(barButtonSystemItem: barButtonSystemItem, target:delegate, action:#selector(Curly.BarButtonItemDelegate.tappedButtonItem))
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItemStyle, closure: @escaping ()->Void) {
        let delegate = Curly.BarButtonItemDelegate.init(tapped: closure)
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target:delegate, action:#selector(Curly.BarButtonItemDelegate.tappedButtonItem))
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
    
    convenience init(image: UIImage?, style: UIBarButtonItemStyle, closure: @escaping ()->Void) {
        let delegate = Curly.BarButtonItemDelegate.init(tapped: closure)
        self.init(image: image, style: style, target:delegate, action:#selector(Curly.BarButtonItemDelegate.tappedButtonItem))
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    convenience init(title: String?, style: UIBarButtonItemStyle, closure: @escaping ()->Void) {
        let delegate = Curly.BarButtonItemDelegate.init(tapped: closure)
        self.init(title: title, style: style, target:delegate, action:#selector(Curly.BarButtonItemDelegate.tappedButtonItem))
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateHandle, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
}

public extension UIControl {
    
    //Objective C support
    public func addAction(_ events:UIControlEvents,block: @escaping (UIControl)->Void)
    {
        self.addAction(events, closure: block)
    }
    
    public func addAction<T:UIControl>(_ events:UIControlEvents,closure: @escaping (T)->Void) {
        var delegateDictionary = objc_getAssociatedObject(self, &CurlyAssociatedDelegateDictionaryHandle) as! [UInt:[Curly.ControlDelegate]]!
        if delegateDictionary == nil {
            delegateDictionary = [:]
        }
        if delegateDictionary?[events.rawValue] == nil {
            delegateDictionary?[events.rawValue] = []
        }
        let delegate = Curly.ControlDelegate.init(received: closure)
        self.addTarget(delegate, action:#selector(Curly.ControlDelegate.recognizedControlEvent(_:)), for: events)
        delegateDictionary?[events.rawValue]!.append(delegate)
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateDictionaryHandle, delegateDictionary, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
    
    public func removeActions(_ events:UIControlEvents) {
        var delegateDictionary = objc_getAssociatedObject(self, &CurlyAssociatedDelegateDictionaryHandle) as! [UInt:[Curly.ControlDelegate]]!
        guard delegateDictionary != nil else { return }
        if let array = delegateDictionary?[events.rawValue] {
            for delegate in array {
                self.removeTarget(delegate, action: #selector(Curly.ControlDelegate.recognizedControlEvent(_:)), for: events)
            }
        }
        delegateDictionary?[events.rawValue] = nil
        objc_setAssociatedObject(self, &CurlyAssociatedDelegateDictionaryHandle, delegateDictionary, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
}

public extension NSObject {
    
    public func deinited(_ closure: @escaping ()->Void) {
        var deinitArray:[Curly.DeinitDelegate] = (objc_getAssociatedObject(self, &CurlyAssociatedDeinitDelegateArrayHandle) as? [Curly.DeinitDelegate]) ?? []
        deinitArray.append(Curly.DeinitDelegate.init(deinited: closure))
        objc_setAssociatedObject(self, &CurlyAssociatedDeinitDelegateArrayHandle, deinitArray, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public func removeDeinitObservers() {
        guard let deinitArray = objc_getAssociatedObject(self, &CurlyAssociatedDeinitDelegateArrayHandle) as? [Curly.DeinitDelegate] else { return }
        for delegate in deinitArray {
            delegate.deinited = nil
        }
        objc_setAssociatedObject(self, &CurlyAssociatedDeinitDelegateArrayHandle, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

//MARK: Curly Class

private class Curly : NSObject {
    
    //MARK: Delegates
    
    fileprivate class ScrollViewDelegate: NSObject, UIScrollViewDelegate {
        
        var willBeginDragging:((_ scrollView: UIScrollView) -> Void)?
        var didScroll:((_ scrollView: UIScrollView) -> Void)?
        var willEndDragging:((_ scrollView: UIScrollView, _ withVelocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)?
        var didEndDragging:((_ scrollView: UIScrollView, _ willDecelerate: Bool) -> Void)?
        var willBeginDecelerating:((_ scrollView: UIScrollView) -> Void)?
        var didEndDecelerating:((_ scrollView: UIScrollView) -> Void)?
        var didEndScrollingAnimation:((_ scrollView: UIScrollView) -> Void)?
        var shouldScrollToTop:((_ scrollView: UIScrollView) -> Bool)?
        var didScrollToTop:((_ scrollView: UIScrollView) -> Void)?
        var willBeginZooming:((_ scrollView: UIScrollView, _ withView: UIView?) -> Void)?
        var didZoom:((_ scrollView: UIScrollView) -> Void)?
        var didEndZooming:((_ scrollView: UIScrollView, _ withView: UIView?, _ atScale: CGFloat) -> Void)?
        var viewForZooming:((_ scrollView:UIScrollView)->UIView?)?
        
        init(willBeginDragging:((_ scrollView: UIScrollView) -> Void)?,didScroll:((_ scrollView: UIScrollView) -> Void)?,willEndDragging:((_ scrollView: UIScrollView, _ withVelocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)?,didEndDragging:((_ scrollView: UIScrollView, _ willDecelerate: Bool) -> Void)?,willBeginDecelerating:((_ scrollView: UIScrollView) -> Void)?,didEndDecelerating:((_ scrollView: UIScrollView) -> Void)?,didEndScrollingAnimation:((_ scrollView: UIScrollView) -> Void)?,shouldScrollToTop:((_ scrollView: UIScrollView) -> Bool)?,didScrollToTop:((_ scrollView: UIScrollView) -> Void)?,willBeginZooming:((_ scrollView: UIScrollView, _ withView: UIView?) -> Void)?,didZoom:((_ scrollView: UIScrollView) -> Void)?,didEndZooming:((_ scrollView: UIScrollView, _ withView: UIView?, _ atScale: CGFloat) -> Void)?,viewForZooming:((_ scrollView:UIScrollView)->UIView?)?){
            
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
        
        @objc func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            willBeginDragging?(scrollView)
        }
        @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
            didScroll?(scrollView)
        }
        @objc func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            willEndDragging?(scrollView,velocity,targetContentOffset)
        }
        @objc func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            didEndDragging?(scrollView,decelerate)
        }
        @objc func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
            willBeginDecelerating?(scrollView)
        }
        @objc func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            didEndDecelerating?(scrollView)
        }
        @objc func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            didEndScrollingAnimation?(scrollView)
        }
        @objc func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
            if let b = shouldScrollToTop?(scrollView) {
                return b
            }else{
                return true
            }
        }
        @objc func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
            didScrollToTop?(scrollView)
        }
        @objc func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
            willBeginZooming?(scrollView,view)
        }
        @objc func scrollViewDidZoom(_ scrollView: UIScrollView) {
            didZoom?(scrollView)
        }
        @objc func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
            didEndZooming?(scrollView,view,scale)
        }
        @objc func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return viewForZooming?(scrollView)
        }
        
    }
    
    fileprivate class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
        
        var willShow:((_ viewController:UIViewController,_ animated:Bool)->Void)?
        var didShow:((_ viewController:UIViewController,_ animated:Bool)->Void)?
        
        init(willShow v_willShow:((_ viewController:UIViewController,_ animated:Bool)->Void)?, didShow v_didShow:((_ viewController:UIViewController,_ animated:Bool)->Void)?) {
            self.willShow = v_willShow
            self.didShow = v_didShow
            super.init()
        }
        
        @objc func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            if willShow != nil {
                willShow!(viewController, animated);
            }
        }
        
        @objc func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
            if didShow != nil {
                didShow!(viewController, animated);
            }
        }
        
    }
    
    
    fileprivate class BarButtonItemDelegate: NSObject {
        let tapped:()->Void
        
        @objc func tappedButtonItem() {
            tapped()
        }
        
        init(tapped:@escaping ()->Void) {
            self.tapped = tapped
            super.init()
        }
    }
    
    fileprivate class GestureRecognizerDelegate: NSObject {
        
        let recognized:(UIGestureRecognizer)->Void
        
        @objc func recognizedGestureRecognizer(_ gr:UIGestureRecognizer) {
            recognized(gr)
        }
        
        init<T:UIGestureRecognizer>(recognized:@escaping (T)->Void) {
            self.recognized = { (gestureRecognizer:UIGestureRecognizer) -> Void in
                if let gr = gestureRecognizer as? T {
                    recognized(gr)
                }
            }
            
            super.init()
        }
    }
    
    fileprivate class ControlDelegate: NSObject {
        
        let received:(UIControl)->Void
        
        @objc func recognizedControlEvent(_ ctl:UIControl) {
            received(ctl)
        }
        
        init<T:UIControl>(received:@escaping (T)->Void) {
            self.received = { (control:UIControl) -> Void in
                if let ctl = control as? T {
                    received(ctl)
                }
            }
            super.init()
        }
    }
    
    fileprivate class DeinitDelegate: NSObject {
        
        var deinited:(()->Void)!
        
        deinit {
            if deinited != nil {
                deinited()
            }
        }
        
        init(deinited:@escaping ()->Void) {
            self.deinited = deinited
            super.init()
        }
        
    }
}



