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
}

@end

@implementation KTButton

#pragma mark - Delegate methods

// Called when the user taps the button
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    // we want to show the 'touched background', which is the reversed gradient for a nice effect
    _touchedBackground.hidden = FALSE;
}

// When the user is done tapping the button
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    // we want to hide the 'touched background' so the view reverts to the normal gradient background
    _touchedBackground.hidden = TRUE;
}

#pragma mark - Initialization methods

- (id)initWithFrame:(CGRect)frame
  andGradientColors:(UIColor*)color, ... {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSMutableArray *colors = [NSMutableArray array];
        va_list args;
        va_start(args, color);
        for (UIColor *arg = color; arg != nil; arg = va_arg(args, UIColor*))
        {
            [colors addObject:arg];
        }
        va_end(args);
        
        // if no colors were sent, default to clear
        if(colors.count == 0) {
            [colors addObject:[UIColor clearColor]];
        }
        
        // set up the default attributes
        self.clipsToBounds = TRUE;

        self.layer.cornerRadius = 6.0f;
        self.layer.borderColor = ((UIColor*)[colors lastObject]).CGColor;
        self.layer.borderWidth = 1.0f;
        
        // and set up the text attributes
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        self.titleLabel.shadowColor = [UIColor colorWithWhite:0.5725490196 alpha:1.0f];
        self.titleLabel.shadowOffset = CGSizeMake(0, -1);
        
        
        // transform the UIColors to a proper list (CGColor-based)
        NSMutableArray *trueColors = [NSMutableArray array];
        for(UIColor *c in colors) {
            [trueColors addObject:(id)c.CGColor];
        }
        
        // create a reversed list for the 'tapped' effect
        NSArray *reversed = [[trueColors reverseObjectEnumerator] allObjects];
       
        // the user-chosen gradient will go in this variable
        _standardBackground = [[UIView alloc] initWithFrame:self.bounds];
        
        // build the gradient
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = _standardBackground.bounds;
        gradient.colors = trueColors;
        
        // add it to the view
        [_standardBackground.layer insertSublayer:gradient atIndex:0];
        _standardBackground.userInteractionEnabled = FALSE;
        
        // finally add the standard view to the back of the button
        [self insertSubview:_standardBackground belowSubview:self.titleLabel];
        
        
        // the reverse of the gradient goes here, and is shown when the user taps the button
        // for a nice 'clicked' effect
        _touchedBackground = [[UIView alloc] initWithFrame:self.bounds];
        _touchedBackground.userInteractionEnabled = FALSE;
        
        // mark it as hidden by default
        _touchedBackground.hidden = TRUE;
        
        // set up the gradient
        CAGradientLayer *reverseGradient = [CAGradientLayer layer];
        reverseGradient.frame = _touchedBackground.bounds;
        reverseGradient.colors = reversed;
        
        // add the gradient to the view
        [_touchedBackground.layer insertSublayer:reverseGradient atIndex:0];
        
        // and finally, the view to just above the standard background.
        // we'll show it when the user taps the button
        [self insertSubview:_touchedBackground aboveSubview:_standardBackground];

    }
    
    return self;
}

@end
