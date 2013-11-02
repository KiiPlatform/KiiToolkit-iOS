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

#import "KTAlertBar.h"

#import "UIColor+KTUtilities.h"
#import "KTDevice.h"
#import <QuartzCore/QuartzCore.h>

// define some bar-specific variables
#define KT_ALERTBAR_TEXT_COLOR      [UIColor whiteColor]
#define KT_ALERTBAR_HEIGHT          36.0f

@implementation KTAlertBar

- (void) configure
{
    // build the container view
    self.backgroundColor = [UIColor clearColor];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 8.0f;
    self.layer.shadowOpacity = 1.0f;
    
    // get the frame for our entire window
    CGRect windowFrame = [[UIApplication sharedApplication] keyWindow].frame;
    
    CGFloat height = [KTDevice isIOS7orLater] ? KT_ALERTBAR_HEIGHT + ktStatusBarHeight : KT_ALERTBAR_HEIGHT;
    
    // construct the frame for our container
    CGRect newViewFrame = self.frame;
    newViewFrame.size.width = windowFrame.size.width;
    newViewFrame.size.height = height;
    newViewFrame.origin.y = -1 * height; // start the label out of the view for a nice animation
    self.frame = newViewFrame;
    
    CGFloat labelY = [KTDevice isIOS7orLater] ? ktStatusBarHeight : 0;
    
    // create a label with the message
    UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, newViewFrame.size.width, height-labelY)];
    toastLabel.text = self.message;
    toastLabel.textColor = KT_ALERTBAR_TEXT_COLOR;
    toastLabel.numberOfLines = 1;
    toastLabel.backgroundColor = [UIColor clearColor];
    toastLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.50f];
    toastLabel.shadowOffset = CGSizeMake(0, -1);
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.font = [UIFont boldSystemFontOfSize:14.0f];

    [self addSubview:toastLabel];
    
    
    // create and add a gradient background for the view
    UIColor *darkRed = [UIColor colorWithHex:@"aa1d1d"];
    UIColor *lightRed = [UIColor colorWithHex:@"d51a1a"];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)lightRed.CGColor, (id)darkRed.CGColor, nil];
    [self.layer insertSublayer:gradient atIndex:0];
    
}

@end
