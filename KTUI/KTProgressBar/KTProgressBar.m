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

#import "KTProgressBar.h"

#import <QuartzCore/QuartzCore.h>

// set some defaults
#define kPadding                    2.0f
#define kBorderWidth                1.0f
#define kCornerRadius               4.0f
#define kProgressAnimationDuration  0.1f

@implementation KTProgressBar

- (void) setProgress:(double)progress
            animated:(BOOL)animated
{
    _progress = progress;
    
    // create the new frame based on the progress value
    CGRect frame = _subProgressView.frame;
    frame.size.width = _progress * (self.frame.size.width - kPadding * 2);
    
    // remove any existing animations so they aren't stacked
    [_subProgressView.layer removeAllAnimations];
    
    // if the method asked for animation
    if(animated) {
        
        // slide the bar in a smooth animation
        [UIView animateWithDuration:kProgressAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _subProgressView.frame = frame;
                         }
                         completion:nil];
    }
    
    // otherwise, just update the frame immediately
    else {
        _subProgressView.frame = frame;
    }
    
}

// override this with animation turned on by default
- (void) setProgress:(double)progress
{
    [self setProgress:progress animated:TRUE];
}

- (id) initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if(self) {
        
        // set up our default values
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [UIColor colorWithWhite:0.6f alpha:0.8f].CGColor;
        self.layer.borderWidth = kBorderWidth;
//        self.layer.cornerRadius = kCornerRadius;
        
        // create the actual sliding view inside the container
        CGRect subFrame = CGRectMake(kPadding, kPadding, frame.size.width-kPadding*2, frame.size.height-kPadding*2);
        _subProgressView = [[UIView alloc] initWithFrame:subFrame];
        _subProgressView.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.8f];
//        _subProgressView.layer.cornerRadius = kCornerRadius/2;
        [self addSubview:_subProgressView];
        
        // set the default value to 0
        [self setProgress:0.0f animated:FALSE];
    }
    
    return self;
    
}

@end
