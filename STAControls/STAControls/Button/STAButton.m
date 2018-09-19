//
//  STAButton.m
//  STAControls
//
//  Created by Aaron Jubbal on 5/18/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "STAButton.h"
#import "STACommon.h"

#define kDefaultBackgroundKey @"defaultBackground"

@interface STAButton ()

@property (nonatomic, assign) UIControlState priorState;
@property (nonatomic, strong, nonnull) NSMutableDictionary *backgroundColorDictionary;

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
                                       forKey:kDefaultBackgroundKey];
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

#pragma mark Public Methods

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    [self.backgroundColorDictionary setObject:(self.backgroundColor) ? self.backgroundColor : [NSNull null]
                                       forKey:kDefaultBackgroundKey];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self.backgroundColorDictionary setObject:backgroundColor forKey:@(state)];
    if (self.state == state) {
        super.backgroundColor = backgroundColor;
    }
}

- (void)setMultilineTitle:(NSString *)title
       withLineAttributes:(NSArray<NSDictionary *> *)attributes
                 forState:(UIControlState)state
{
    NSArray<NSValue *> *matches = inBetweenSubstring(title, @"\n");
        
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    NSDictionary<NSString *, id> *attributesDict = nil;
    for (int i = 0; i < matches.count; i++) {
        NSRange match;
        NSValue *value = matches[i];
        [value getValue:&match];
        
        if (i < attributes.count) {
            attributesDict = attributes[i];
        }
        if (attributesDict) {
            [attributedString addAttributes:attributesDict range:match];
        }
    }
    
    [super setAttributedTitle:attributedString forState:state];
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

#pragma mark Helper Methods

- (void)stateChangedFrom:(UIControlState)oldState to:(UIControlState)newState {
    UIColor *backgroundColor = [self.backgroundColorDictionary objectForKeyNotNull:@(newState)];
    if (backgroundColor) {
        super.backgroundColor = backgroundColor;
    } else {
        UIColor *defaultColor = [self.backgroundColorDictionary objectForKeyNotNull:kDefaultBackgroundKey];
        if ([defaultColor isMemberOfClass:[NSNull class]]) {
            defaultColor = nil;
        }
        super.backgroundColor = defaultColor;
    }
}

- (void)checkForStateChange {
    if (self.state != self.priorState) {
        [self stateChangedFrom:self.priorState to:self.state];
        self.priorState = self.state;
    }
}

// starting point reference: https://stackoverflow.com/a/42744150/347339
NSRange makeRangeFromIndex(NSUInteger index, NSUInteger length) {
    return NSMakeRange(index, length - index);
}

// starting point reference: https://stackoverflow.com/a/42744150/347339
NSArray<NSValue *> * inBetweenSubstring(NSString *text, NSString *pattern) {
    NSMutableArray *matchingRanges = [NSMutableArray new];
    NSUInteger textLength = text.length;
    NSRange match = makeRangeFromIndex(0, textLength);
    
    NSUInteger indexAfterSubstring = 0;
    while(match.location != NSNotFound) {
        match = [text rangeOfString:pattern options:0L range:match];
        if (match.location != NSNotFound) { // substring found
            NSRange inBetweenRange = NSMakeRange(indexAfterSubstring, match.location - indexAfterSubstring);
            [matchingRanges addObject:[NSValue valueWithRange:inBetweenRange]];
            indexAfterSubstring = match.location + match.length;
            match = makeRangeFromIndex(indexAfterSubstring, textLength);
        } else { // substring not found
            // after last found character to end of string
            NSUInteger length = textLength - indexAfterSubstring;
            if (length > 0) { // ensure text doesn't end in pattern
                NSRange inBetweenRange = NSMakeRange(indexAfterSubstring, length);
                [matchingRanges addObject:[NSValue valueWithRange:inBetweenRange]];
            }
        }
    }
    
    return [matchingRanges copy];
}

@end
