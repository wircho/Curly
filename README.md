Curly
=====

iOS library adding *closure* (*block* or *callback*) functionality to several native classes (buttons, sliders, notifications, etc).

This library is written in **Swift** but it also works in **Objective-C**. Make sure to read the installation notes below.

Contents
--------

1. [Installation](#1-installation)
2. [Usage](#2-usage)
  * [Buttons, Sliders, etc (UIControl)](#buttons-sliders-etc-uicontrol)
  * [~~Alert Views~~ (No longer supported. Use `UIAlertController`)](#alert-views)
  * [Notifications](#notifications)
  * [Gesture Recognizers](#gesture-recognizers)
  * [Some Delegates](#some-delegates)
  * [Observing an Object's Deinit (Dealloc)](#observing-an-objects-deinit-dealloc)

1. Installation
------------

Just add Curly.swift to your project, or use [CocoaPods](https://cocoapods.org):

```
pod "Curly", :git => 'https://github.com/wircho/Curly.git', :branch => 'master'
```

This library is written in **Swift** but it also works in **Objective-C**. If you are using Objective-C, make sure you add `#import "[YourProjectName]-Swift.h"` at the beginning of your Objective-C file. You may need to compile once for the Swift methods to be recognized by Xcode's Objective-C editor.

2. Usage
-----

You can preview the functionality below by running the sample project in the **CurlySample** folder

### Buttons, Sliders, etc (UIControl): ###

##### Swift: #####

```swift
button.addAction(.TouchUpInside) {
    (bttn:UIButton) -> Void in
    
    print("tapped button")
            
}
```

```swift
slider.addAction(.ValueChanged) {
    (sldr:UISlider) -> Void in
    
    print("moved slider")
            
}
```

This works with any subclass of UIControl.

##### Objective-C: #####

```objective-c
[button addAction:UIControlEventTouchUpInside block:^(UIControl *bttn) {
                
    NSLog(@"tapped button");
                
}];
```

```objective-c
[slider addAction:UIControlEventValueChanged block:^(UIControl *sldr) {
                
    NSLog(@"moved slider");
                
}];
```

### ~~Alert Views:~~ ###

This functionality is no longer supported by Curly. Please use [`UIAlertController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIAlertController_class/).

### Notifications: ###

##### Swift: #####

```swift
"SOME-NOTIFICATION-NAME".observeFrom(self) {
    innerSelf, note in
    
    print("Listening to NSNotification \(note) from \(innerSelf)")
}
```

The code above has the added advantage that the observation stops as soon as `self` is released/deinited. If you would like to have more control, the method above returns a `CurlyNotificationToken` which you may keep and cancel at any time using `token.cancel()`.

##### Objective-C: #####

No special Objective-C support yet.

### Gesture Recognizers: ###

##### Swift: #####

```swift
let gestureRecognizer = UIPanGestureRecognizer {
    (gr:UIPanGestureRecognizer)->Void in
                
    print("gesture recognizer: \(gr)")
    
}
```
This works with any subclass of UIGestureRecognizer.

##### Objective-C: #####

```objective-c
UIPanGestureRecognizer *gestureRecognizer
= [[UIPanGestureRecognizer alloc] initWithBlock:^(UIGestureRecognizer *gr) {
                
    NSLog(@"gesture recognizer: %@",gr);
                
}];
```

### Some Delegates: ###

With Curly you can define delegates for UIScrollView and UINavigationController using only closures/blocks.

##### Swift: #####

```swift
scrollView.setDelegate(
    didScroll: { (scrollView:UIScrollView) -> Void in
        print("did scroll")
    }
 )
```

For the complete `UIScrollViewDelegate` functionality use `.setDelegate(willBeginDragging:,didScroll:,willEndDragging:,didEndDragging:,willBeginDecelerating:,didEndDecelerating:,didEndScrollingAnimation:,shouldScrollToTop:,didScrollToTop:,willBeginZooming:,didZoom:,didEndZooming:,viewForZooming:)`

```swift
navigationController.setDelegate(
    willShow: { (viewController:UIViewController) -> Void in
        print("will show")
    },
    didShow: { (viewController:UIViewController) -> Void in
        print("did show")
    }
 )
```

The second parameter `didShow` is optional.

##### Objective-C: #####

```objective-c
[scrollView setDelegateWithDidScroll:^(UIScrollView *scrollView) {
    NSLog(@"did scroll");
}];
```

For the complete `UIScrollViewDelegate` functionality use `setDelegateWithWillBeginDragging:didScroll:willEndDragging:didEndDragging:willBeginDecelerating:didEndDecelerating:didEndScrollingAnimation:shouldScrollToTop:didScrollToTop:willBeginZooming:didZoom:didEndZooming:viewForZooming:`
o
```objective-c
[navigationController setDelegateWithWillShow:^(UIViewController *viewController, BOOL animated) {
    NSLog(@"will show");
} didShow:^(UIViewController *viewController, BOOL animated) {
    NSLog(@"did show");
}];
```

### Observing an Object's Deinit (Dealloc): ###

The method below works with any subclass of NSObject. Unfortunately, as of now, you cannot refer to your object or its properties inside the closure. In fact, any weak reference to the object will be nil by the time you are in the closure.

##### Swift: #####

```swift
object.deinited {
    print("object has been deinited")
}
```

##### Objective-C: #####

```objective-c
[object deinited:^{
    NSLog(@"object has been deinited");   
}];
```
