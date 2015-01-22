//
//  STAPickerView.m
//  STATextField
//
//  Created by Aaron Jubbal on 1/13/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "STAPickerViewBase.h"
#import "STAPickerView+PrivateHeaders.h"

#pragma mark - Private Delegate

@interface STAPickerViewPrivateDelegate : NSObject <UIPickerViewDelegate> {
@public
    __weak id<UIPickerViewDelegate> _userDelegate;
}
@end

@implementation STAPickerViewPrivateDelegate

- (BOOL)respondsToSelector:(SEL)selector {
    return [_userDelegate respondsToSelector:selector] || [super respondsToSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    // This should only ever be called from `UITextField`, after it has verified
    // that `_userDelegate` responds to the selector by sending me
    // `respondsToSelector:`.  So I don't need to check again here.
    [invocation invokeWithTarget:_userDelegate];
}

#pragma mark Delegate Overrides

- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component
{
    CGFloat rowHeight = [(STAPickerViewBase *)pickerView pickerView:pickerView rowHeightForComponent:component];
    if ([_userDelegate respondsToSelector:_cmd]) {
        rowHeight = [_userDelegate pickerView:pickerView rowHeightForComponent:component];
    }
    return rowHeight;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    CGFloat rowWidth = [(STAPickerViewBase *)pickerView pickerView:pickerView widthForComponent:component];
    if ([_userDelegate respondsToSelector:_cmd]) {
        rowWidth = [_userDelegate pickerView:pickerView widthForComponent:component];
    }
    return rowWidth;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSString *title = [(STAPickerViewBase *)pickerView pickerView:pickerView titleForRow:row forComponent:component];
    if ([_userDelegate respondsToSelector:_cmd]) {
        title = [_userDelegate pickerView:pickerView titleForRow:row forComponent:component];
    }
    return title;
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
//             attributedTitleForRow:(NSInteger)row
//                      forComponent:(NSInteger)component
//{
//    NSAttributedString *attributedTitle = [(STAPickerViewBase *)pickerView pickerView:pickerView attributedTitleForRow:row forComponent:component];
//    if ([_userDelegate respondsToSelector:_cmd]) {
//        attributedTitle = [_userDelegate pickerView:pickerView attributedTitleForRow:row forComponent:component];
//    }
//    return attributedTitle;
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView
//            viewForRow:(NSInteger)row
//          forComponent:(NSInteger)component
//           reusingView:(UIView *)view
//{
//    UIView *rowView = [(STAPickerViewBase *)pickerView pickerView:pickerView viewForRow:row forComponent:component reusingView:view];
//    if ([_userDelegate respondsToSelector:_cmd]) {
//        rowView = [_userDelegate pickerView:pickerView viewForRow:row forComponent:component reusingView:view];
//    }
//    return rowView;
//}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    [(STAPickerViewBase *)pickerView pickerView:pickerView didSelectRow:row inComponent:component];
    if ([_userDelegate respondsToSelector:_cmd]) {
        [_userDelegate pickerView:pickerView didSelectRow:row inComponent:component];
    }
}

@end

#pragma mark - Private Data Source

@interface STAPickerViewPrivateDataSource : NSObject <UIPickerViewDataSource> {
@public
    __weak id<UIPickerViewDataSource> _userDataSource;
}
@end

@implementation STAPickerViewPrivateDataSource

- (BOOL)respondsToSelector:(SEL)selector {
    return [_userDataSource respondsToSelector:selector] || [super respondsToSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    // This should only ever be called from `UITextField`, after it has verified
    // that `_userDelegate` responds to the selector by sending me
    // `respondsToSelector:`.  So I don't need to check again here.
    [invocation invokeWithTarget:_userDataSource];
}

#pragma mark Data Source Overrides

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSInteger numberOfComponents = [(STAPickerViewBase *)pickerView numberOfComponentsInPickerView:pickerView];
    if ([_userDataSource respondsToSelector:_cmd]) {
        [_userDataSource numberOfComponentsInPickerView:pickerView];
    }
    return numberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSInteger numberOfRows = [(STAPickerViewBase *)pickerView pickerView:pickerView numberOfRowsInComponent:component];
    if ([_userDataSource respondsToSelector:_cmd]) {
        [_userDataSource pickerView:pickerView numberOfRowsInComponent:component];
    }
    return numberOfRows;
}

@end

#pragma mark - STAPickerView

@interface STAPickerViewBase () {
    STAPickerViewPrivateDelegate *_internalDelegate;
    STAPickerViewPrivateDataSource *_internalDataSource;
}

@end

@implementation STAPickerViewBase

- (void)initInternal {
    
    _internalDelegate = [STAPickerViewPrivateDelegate new];
    _internalDataSource = [STAPickerViewPrivateDataSource new];
    [super setDelegate:_internalDelegate];
    [super setDataSource:_internalDataSource];
}

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    [self initInternal];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    [self initInternal];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (!(self = [super initWithCoder:aDecoder])) {
        return nil;
    }
    [self initInternal];
    return self;
}

#pragma mark Setters/Getters

- (void)setDelegate:(id<UIPickerViewDelegate>)delegate {
    _internalDelegate->_userDelegate = delegate;
    // Scroll view delegate caches whether the delegate responds to some of the delegate
    // methods, so we need to force it to re-evaluate if the delegate responds to them
    super.delegate = nil;
    super.delegate = (id)_internalDelegate;
}

- (id<UIPickerViewDelegate>)delegate {
    return _internalDelegate->_userDelegate;
}

- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource {
    _internalDataSource->_userDataSource = dataSource;
    // Scroll view delegate caches whether the delegate responds to some of the delegate
    // methods, so we need to force it to re-evaluate if the delegate responds to them
    super.dataSource = nil;
    super.dataSource = (id)_internalDataSource;
}

- (id<UIPickerViewDataSource>)dataSource {
    return _internalDataSource->_userDataSource;
}

#pragma mark Delegate Methods

- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return 44.0; // TODO: make this a constant
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return [UIScreen mainScreen].bounds.size.width;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return nil;
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
//             attributedTitleForRow:(NSInteger)row
//                      forComponent:(NSInteger)component
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    return nil;
//}

//- (UIView *)pickerView:(UIPickerView *)pickerView
//            viewForRow:(NSInteger)row
//          forComponent:(NSInteger)component
//           reusingView:(UIView *)view
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    return nil;
//}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
}

#pragma mark Data Source Overrides

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return 0;
}

@end
