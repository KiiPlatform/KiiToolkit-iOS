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

#import "KTAlertToast.h"

#import <QuartzCore/QuartzCore.h>

// define some toast-specific variables
#define KT_TOAST_PADDING            10
#define KT_TOAST_MAX_WIDTH          220
#define KT_TOAST_CORNER_RADIUS      8.0
#define KT_TOAST_TEXT_COLOR         [UIColor whiteColor]
#define KT_TOAST_BOTTOM_MARGIN      30

@implementation KTAlertToast

- (void) configure
{
    
    // build the toast container view
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    self.alpha = 0.0f; // start faded out for nice animation
    self.layer.cornerRadius = KT_TOAST_CORNER_RADIUS;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = 0.8f;
    
    // build the text label
    UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    toastLabel.text = self.message;
    toastLabel.textColor = KT_TOAST_TEXT_COLOR;
    toastLabel.numberOfLines = 1000;
    toastLabel.backgroundColor = [UIColor clearColor];
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.lineBreakMode = NSLineBreakByWordWrapping;
    toastLabel.font = [UIFont systemFontOfSize:14.0f];
    
    // resize the label based on the message length
    CGSize maximumLabelSize = CGSizeMake(KT_TOAST_MAX_WIDTH, 9999);
    CGSize expectedLabelSize = [toastLabel.text sizeWithFont:toastLabel.font
                                           constrainedToSize:maximumLabelSize
                                               lineBreakMode:toastLabel.lineBreakMode];
    
    // adjust the label to the desired size
    CGRect newLabelFrame = toastLabel.frame;
    newLabelFrame.size = CGSizeMake(expectedLabelSize.width, expectedLabelSize.height);
    newLabelFrame.origin = CGPointMake(KT_TOAST_PADDING, KT_TOAST_PADDING); // have an offset for padding
    toastLabel.frame = newLabelFrame;
    
    // add the toast label to the alert (centered with padding)
    CGRect newViewFrame = self.frame;
    newViewFrame.size.width = newLabelFrame.size.width + KT_TOAST_PADDING * 2;
    newViewFrame.size.height = newLabelFrame.size.height + KT_TOAST_PADDING * 2;
    self.frame = newViewFrame;
    
    // add the label to its container
    [self addSubview:toastLabel];
    
    // get the window frame to determine placement
    CGRect windowFrame = [[UIApplication sharedApplication] keyWindow].frame;
    
    // set the Y-position so the base is KT_TOAST_BOTTOM_MARGIN pixels off the bottom of the screen
    NSUInteger yOffset = windowFrame.size.height - (self.frame.size.height / 2) - KT_TOAST_BOTTOM_MARGIN;
    
    // align the toast properly
    self.center = CGPointMake(160, yOffset);
    
    // round the x/y coords so they aren't 'split' between values (would appear blurry)
    self.frame = CGRectMake(round(self.frame.origin.x), round(self.frame.origin.y), self.frame.size.width, self.frame.size.height);
    
}

@end
