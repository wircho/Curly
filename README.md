Curly
=====

iOS (Swift with Objective-C support) library adding *closure* (*block* or *callback*) functionality to several UIKit classes (alert views, buttons, sliders, storyboard segues, gesture recognizers, etc)

Installation
------------

Just add Curly.swift to your project :)

Usage
-----

You can preview the functionality below by running the sample project in the **CurlySample** folder

### Alert Views: ###

##### Swift: #####
```
alertView.show(didDismiss:{(alertView:UIAlertView, buttonIndex:Int) -> Void in

    println("dismissed with button at index \(buttonIndex)")
            
})
```
Other methods are: `.show(clicked:)`, `.show(willDismiss:)` and the more complete version `.show(clicked:willPresent:didPresent:willDismiss:didDismiss:canceled:shouldEnableFirstOtherButton:)`

##### Objective-C: #####
```
[alertView showWithDidDismiss:^(UIAlertView *alertView, NSInteger buttonIndex) {

    NSLog(@"dismissed with button at index %d",(int)buttonIndex);
    
}];
```

The other Objective-C methods are: `showWithclicked:`, `.showWithWillDismiss:` and the more complete version `.showWithClicked:willPresent:didPresent:willDismiss:didDismiss:canceled:shouldEnableFirstOtherButton:`

### Buttons, Sliders, etc (UIControl): ###

```
button.addAction(.TouchUpInside) {
    (bttn:UIButton) -> Void in
    
    println("tapped button")
            
}
```

```
slider.addAction(.ValueChanged) {
    (sldr:UISlider) -> Void in
    
    println("moved slider")
            
}
```


This works with any subclass of UIControl.

### Storyboard Segues: ###

```
self.performSegueWithIdentifier("segue", sender: nil) {
    (segue:UIStoryboardSegue, sender:AnyObject?) -> Void in
            
    println("preparing for segue!")
            
}
```

This works as long as you don't override `prepareForSegue:` in your `UIViewController`'s subclass.

### Gesture Recognizers: ###

```
let gestureRecognizer = UIPanGestureRecognizer {
    (gr:UIPanGestureRecognizer)->Void in
                
    switch gr.state {
    case .Began:
        println("began!")
    case .Changed:
        println("moved!")
    case .Ended:
        println("ended!")
    default:
        break
    }
    
}
```
This works with any subclass of UIGestureRecognizer.

### Observing an Object's Deinit (Dealloc): ###

```
object.deinited {
    println("object has been deinited")
}
```

This works with any subclass of NSObject. Unfortunately, as of now, you cannot refer to your object or its properties inside the closure. In fact, any weak reference to the object will be nil by the time you are in the closure.
