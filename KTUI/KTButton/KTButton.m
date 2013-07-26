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

#import "KTButton.h"

#import <QuartzCore/QuartzCore.h>

@interface KTButton () {
    UIView *_standardBackground;
    UIView *_touchedBackground;
    
    NSMutableArray *_backgroundColors;
}

@end

@implementation KTButton

#pragma mark - Setters

- (void) drawGradients
{
    
    // if no colors were sent, default to clear
    if(_backgroundColors.count == 0) {
        [_backgroundColors addObject:[UIColor clearColor]];
    }
    
    // transform the UIColors to a proper list (CGColor-based)
    NSMutableArray *trueColors = [NSMutableArray array];
    for(UIColor *c in _backgroundColors) {
        [trueColors addObject:(id)c.CGColor];
    }
    
    // create a reversed list for the 'tapped' effect
    NSArray *reversed = [[trueColors reverseObjectEnumerator] allObjects];
    
    
    // build the gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _standardBackground.bounds;
    gradient.colors = trueColors;
    
    // remove all the existing layers
    for(CALayer *layer in _standardBackground.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    // and add the new one
    [_standardBackground.layer insertSublayer:gradient atIndex:0];
    
    
    // set up the gradient
    CAGradientLayer *reverseGradient = [CAGradientLayer layer];
    reverseGradient.frame = _touchedBackground.bounds;
    reverseGradient.colors = reversed;
    
    // remove all the existing layers
    for(CALayer *layer in _touchedBackground.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    // and set the border
    self.layer.borderColor = _borderColor.CGColor;
    
    // add the gradient to the view
    [_touchedBackground.layer insertSublayer:reverseGradient atIndex:0];

}

- (void) setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self drawGradients];
}

- (void) setGradientColors:(UIColor*)color, ...
{
        
    // clear the existing colors
    [_backgroundColors removeAllObjects];
    
    // set the new colors
    va_list args;
    va_start(args, color);
    for (UIColor *arg = color; arg != nil; arg = va_arg(args, UIColor*))
    {
        [_backgroundColors addObject:arg];
    }
    va_end(args);
    
    // draw the background
    [self drawGradients];
}

#pragma mark - Delegate methods

// Called when the user taps the button
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    // we want to show the 'touched background', which is the reversed gradient for a nice effect
    _touchedBackground.hidden = FALSE;
}

// When the user is done tapping the button
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    // we want to hide the 'touched background' so the view reverts to the normal gradient background
    _touchedBackground.hidden = TRUE;
}

#pragma mark - Initialization methods

- (id)initWithFrame:(CGRect)frame
  andGradientColors:(UIColor*)color, ...
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _backgroundColors = [[NSMutableArray alloc] init];
                
        // set up the default attributes
        self.clipsToBounds = TRUE;

        self.layer.cornerRadius = 6.0f;
        self.layer.borderWidth = 1.0f;
        
        // and set up the text attributes
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        self.titleLabel.shadowColor = [UIColor colorWithWhite:0.5725490196 alpha:1.0f];
        self.titleLabel.shadowOffset = CGSizeMake(0, -1);

        
        // the user-chosen gradient will go in this variable
        _standardBackground = [[UIView alloc] initWithFrame:self.bounds];
        _standardBackground.userInteractionEnabled = FALSE;
        
        // finally add the standard view to the back of the button
        [self insertSubview:_standardBackground belowSubview:self.titleLabel];
        
        
        // the reverse of the gradient goes here, and is shown when the user taps the button
        // for a nice 'clicked' effect
        _touchedBackground = [[UIView alloc] initWithFrame:self.bounds];
        _touchedBackground.userInteractionEnabled = FALSE;
        
        // mark it as hidden by default
        _touchedBackground.hidden = TRUE;
        
        // set the new colors
        // TODO: this is written twice. consoldiate
        va_list args;
        va_start(args, color);
        for (UIColor *arg = color; arg != nil; arg = va_arg(args, UIColor*))
        {
            [_backgroundColors addObject:arg];
        }
        va_end(args);
        
        // if we have a gradient, assign it to the bottom value
        if(_backgroundColors.count > 0) {
            _borderColor = [_backgroundColors lastObject];
        }
        
        // otherwise, make the border clear
        else {
            _borderColor = [UIColor clearColor];
        }

        // draw the background
        [self drawGradients];

        // and finally, the view to just above the standard background.
        // we'll show it when the user taps the button
        [self insertSubview:_touchedBackground aboveSubview:_standardBackground];

    }
    
    return self;
}

@end
