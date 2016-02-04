# STAControls #

[![Build Status](https://travis-ci.org/Stunner/STAControls.svg?branch=master)](https://travis-ci.org/Stunner/STAControls)

STAControls is a collection of classes that aim to make dealing with Cocoa's UIControl subclasses more convenient, and to reduce the complexity of the code you write when getting these controls to do things that really ought to be provided out-of-the-box:

* dismissing the keyboard when the *return* key is pressed
* switching to another text field when the *return* key is pressed
* having placeholder text reappear when the text field is no longer first responder (and text field is still blank)
* providing `setBackgroundColor:forState:` method for UIButton (STAButton)
* togglable segments in a UISegmentedControl (STASegmentedControl)
* display an accessory view that allows for fast switching between adjacent UIControls (with system chevrons) & "Done" button
* max character length (STATextField)
* easily denote titles in a UIPickerView (STAPickerView)

As well as more advanced things such as:

* provide a date text field (STADateField)
* provide an ATM text field (STAATMTextField) which takes in currency input like an ATM machine
* currency representation support within a text field (STATextField)
* support for intercepting delegate methods within the subclass (because sometimes you want the UIControl to be aware of when things concerning it change)
* resizing support to accomodate clear text button view (STAResizingTextField)
* ReactiveCocoa support

Installation
------------

*Note:* This project will be put on CocoaPods for version 1, which is currently being worked toward.

Merely copy the [STAControls](https://github.com/Stunner/STAControls/tree/master/STAControls/STAControls) directory into your project.

Usage
-----

Import library for usage with `#import "STAControls.h"`, then merely use as any other UIControl subclass. Consult the header files to see what additional functionality each class provides.
