//
//  STAButton.m
//  STAControls
//
//  Created by Aaron Jubbal on 5/18/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "STAButton.h"
#import "STACommon.h"

@interface STAButton ()

@property (nonatomic, assign) UIControlState priorState;
@property (nonatomic, strong) NSMutableDictionary *backgroundColorDictionary;

@end

// reference: http://stackoverflow.com/a/11164761/347339
@implementation STAButton

#pragma mark Initialization

- (instancetype)init {
    if (self = [super init]) {
        [self initInternal];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initInternal];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initInternal];
    }
    return self;
}

- (void)initInternal {
    self.backgroundColorDictionary = [[NSMutableDictionary alloc] initWithCapacity:5];
    [self.backgroundColorDictionary setObject:(self.backgroundColor) ? self.backgroundColor : [NSNull null]
                                       forKey:@"default"];
}

#pragma mark Setters

- (void)setEnabled:(BOOL)enabled {
    self.priorState = self.state;
    [super setEnabled:enabled];
    [self checkForStateChange];
}

- (void)setSelected:(BOOL)selected {
    self.priorState = self.state;
    [super setSelected:selected];
    [self checkForStateChange];
}

- (void)setHighlighted:(BOOL)highlighted {
    self.priorState = self.state;
    [super setHighlighted:highlighted];
    [self checkForStateChange];
}

#pragma mark Gesture Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.priorState = self.state;
    [super touchesBegan:touches withEvent:event];
    [self checkForStateChange];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.priorState = self.state;
    [super touchesMoved:touches withEvent:event];
    [self checkForStateChange];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.priorState = self.state;
    [super touchesEnded:touches withEvent:event];
    [self checkForStateChange];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.priorState = self.state;
    [super touchesCancelled:touches withEvent:event];
    [self checkForStateChange];
}

#pragma mark Public Methods

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    [self.backgroundColorDictionary setObject:(self.backgroundColor) ? self.backgroundColor : [NSNull null]
                                       forKey:@"default"];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self.backgroundColorDictionary setObject:backgroundColor forKey:@(state)];
    if (self.state == state) {
        super.backgroundColor = backgroundColor;
    }
}

#pragma mark Helper Methods

- (void)stateChangedFrom:(UIControlState)oldState to:(UIControlState)newState {
    UIColor *backgroundColor = [self.backgroundColorDictionary objectForKeyNotNull:@(newState)];
    if (backgroundColor) {
        super.backgroundColor = backgroundColor;
    } else {
        UIColor *defaultColor = [self.backgroundColorDictionary objectForKeyNotNull:@"default"];
        super.backgroundColor = defaultColor;
    }
}

- (void)checkForStateChange {
    if (self.state != self.priorState) {
        [self stateChangedFrom:self.priorState to:self.state];
        self.priorState = self.state;
    }
}

@end
