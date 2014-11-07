Curly
=====

Swift library adding *closure* (*block* or *callback*) functionality to several UIKit classes (alert views, buttons, sliders, storyboard segues, gesture recognizers, etc)

Installation
------------

Just add Curly.swift to your project :)

Usage
-----

You can preview the functionality below by running the sample project in the **CurlySample** folder

### Alert views: ###

```
alert.show(didDismiss:{(alertView:UIAlertView, buttonIndex:Int) -> Void in

    let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
            
    if buttonIndex == alertView.cancelButtonIndex {
        println("dismissed with cancel button: \(buttonTitle)")
    }else{
        println("dismissed with button: \(buttonTitle)")
    }
            
})
```

Other methods are `alert.show(clicked:)`, `alert.show(willDismiss:)` and the more complete version `show(clicked:willPresent:didPresent:willDismiss:didDismiss:canceled:shouldEnableFirstOtherButton:)`

### Buttons, sliders, etc (UIControl): ###

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
