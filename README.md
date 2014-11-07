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

##### Swift: #####

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

##### Objective-C: #####

```
[button addAction:UIControlEventTouchUpInside block:^(UIControl *bttn) {
                
    NSLog(@"tapped button");
                
}];
```

```
[slider addAction:UIControlEventValueChanged block:^(UIControl *sldr) {
                
    NSLog(@"moved slider");
                
}];
```

### Storyboard Segues: ###

##### Swift: #####

```
self.performSegueWithIdentifier("segue", sender: nil) {
    (segue:UIStoryboardSegue, sender:AnyObject?) -> Void in
            
    println("preparing for segue!")
            
}
```

##### Objective-C: #####

```
[[UIViewController alloc] performSegueWithIdentifier:@"segue" sender:nil preparation:^(UIStoryboardSegue *segue, id sender) {
                
    NSLog(@"preparing for segue!");
                
}];
```

This works as long as you don't override `prepareForSegue` in your `UIViewController`'s subclass.

### Gesture Recognizers: ###

##### Swift: #####

```
let gestureRecognizer = UIPanGestureRecognizer {
    (gr:UIPanGestureRecognizer)->Void in
                
    println("gesture recognizer: \(gr)")
    
}
```
This works with any subclass of UIGestureRecognizer.

##### Objective-C: #####

```
UIPanGestureRecognizer *gestureRecognizer
= [[UIPanGestureRecognizer alloc] initWithBlock:^(UIGestureRecognizer *gr) {
                
    NSLog(@"gesture recognizer: %@",gr);
                
}];
```

### Observing an Object's Deinit (Dealloc): ###

##### Swift: #####

```
object.deinited {
    println("object has been deinited")
}
```

##### Objective-C: #####

```
[object deinited:^{
    NSLog(@"object has been deinited");   
}];
```

This works with any subclass of NSObject. Unfortunately, as of now, you cannot refer to your object or its properties inside the closure. In fact, any weak reference to the object will be nil by the time you are in the closure.
