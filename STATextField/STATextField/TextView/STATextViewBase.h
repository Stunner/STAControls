//
//  STATextViewBase.h
//  STATextField
//
//  Created by Aaron Jubbal on 11/23/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Responsible for handling the delegate forwarding/overriding and establishing methods
 that may be overridden.
 
 Delegate forwarding occurs by first calling self's implementation of the delegate, and 
 then the user's. If self's delegate method returns NO, the return value from the user's 
 delegate method is not honored, otherwise, it is.
 
 Consult STATextViewBase+PrivateHeaders.h for a list of all overridable methods.
 */
@interface STATextViewBase : UITextView

@end
