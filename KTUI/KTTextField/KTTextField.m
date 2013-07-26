//
//
// Copyright 2013 Kii Corporation
// http://kii.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//

#import "KTTextField.h"

#import <QuartzCore/QuartzCore.h>

// define some constants
#define KTGlowOpacity           0.9f
#define KTAnimationDuration     0.3f

@interface KTTextField()
- (void) redraw;
@end

@implementation KTTextField

#pragma mark - Customized setters
- (void) setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self redraw];
}

- (void) setGlows:(BOOL)glows {
    _glows = glows;
    [self redraw];
}

#pragma mark - Delegate methods

// The text field has begun editing
- (void) didBeginEditing:(KTTextField*)textField
{
    
    // add an animation to the layer which nicely shows the glow
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    animation.duration = KTAnimationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:KTGlowOpacity];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [self.layer addAnimation:animation forKey:@"shadowOpacity"];

}

// The text field has ended editing
- (void) didEndEditing:(KTTextField*)textField
{
    
    // add an animation to the layer which nicely removes the glow
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    animation.duration = KTAnimationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:KTGlowOpacity];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [self.layer addAnimation:animation forKey:@"shadowOpacity"];
    
}

#pragma mark - View methods
- (void) redraw {
    
    self.layer.borderColor = _borderColor.CGColor;
    
    // tone the border color down for the glow effect
    const float* colors = CGColorGetComponents(_borderColor.CGColor);
    self.layer.borderColor = [UIColor colorWithRed:colors[0] green:colors[1] blue:colors[2] alpha:0.6f].CGColor;
    
    // if the object should glow, add the UI that's needed
    if(_glows) {
        
        // set the attributes
        self.layer.shadowColor = _borderColor.CGColor;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 2.0f;
        self.layer.masksToBounds = FALSE;
        
        // and listen to the editing events, so we know when to show/hide the glow
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didBeginEditing:)
                                                     name:UITextFieldTextDidBeginEditingNotification
                                                   object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didEndEditing:)
                                                     name:UITextFieldTextDidEndEditingNotification
                                                   object:self];
        
    }

}

#pragma mark - Initialization methods

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // to show the outer glow, make sure we're not clipping
        self.clipsToBounds = FALSE;
        
        _borderColor = [UIColor clearColor];
        
        // align the text vertically in the middle
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        // set the padding
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, frame.size.height)];
        self.leftView = paddingView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        // and some other attributes
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1.0f;
        self.font = [UIFont systemFontOfSize:14.0f];

        [self redraw];
    }
    
    return self;
}

#pragma mark - Static creation methods

+ (KTTextField*) textFieldWithFrame:(CGRect)frame
                     andBorderColor:(UIColor*)borderColor
                           andGlows:(BOOL)glows
{
    
    KTTextField *field = [[KTTextField alloc] initWithFrame:frame];
    field.borderColor = borderColor;
    field.glows = glows;
    return field;
    
}

@end
