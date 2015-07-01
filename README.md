# STAControls #

STAControls is a collection of classes that aim to make dealing with Cocoa's UIControl subclasses more convenient, and to reduce the complexity of the code you write when getting these controls to do seemingly no-brainer things such as:

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
* support for intercepting delegate methods within the subclass
* resizing support to accomodate clear text button view (STAResizingTextField)
* ReactiveCocoa support

**More info coming soon!**
