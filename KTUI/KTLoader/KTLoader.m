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

#import "KTLoader.h"

// Constants
#define KTLoaderFadeDuration    0.3

@implementation KTLoader

#pragma mark - Display methods

+ (void) showLoader:(NSString*)msg
           animated:(BOOL)animated
{
    
    // hide any pre-existing loaders
    [KTLoader hideLoader:animated];
    
    // generate the new loader
    KTLoader *loader = [[KTLoader alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    loader.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.9f];
    
    // if it should be animated, start with 0.0 alpha so it can be faded in
    loader.alpha = animated ? 0.0f : 1.0f;
    
    // create the message label
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 30)];
    message.textAlignment = NSTextAlignmentCenter;
    message.font = [UIFont boldSystemFontOfSize:14.0f];
    message.textColor = [UIColor whiteColor];
    message.text = msg;
    message.backgroundColor = [UIColor clearColor];
    [loader addSubview:message];
    
    // add an animated activity indicator
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = CGPointMake(160, 256);
    [loader addSubview:activity];
    [activity startAnimating];
    
    // add the loader to the root window (so it overlays everything)
    [[[UIApplication sharedApplication] keyWindow] addSubview:loader];
    
    // if it should animate in, do so
    if(animated) {
        [UIView animateWithDuration:KTLoaderFadeDuration
                         animations:^{
                             
                             // fade in to full opacity
                             loader.alpha = 1.0f;
                         }];
    }
    
}


+ (void) hideLoader:(BOOL)animated
{
    
    // iterate through all subviews of the main window
    for(UIView *v in [[[UIApplication sharedApplication] keyWindow] subviews]) {
        
        // if it's a KTLoader view, we want to hide it
        if([v isKindOfClass:[KTLoader class]]) {
            
            // if the process should be animated
            if(animated) {
                
                // fade it out nicely
                [UIView animateWithDuration:KTLoaderFadeDuration
                                 animations:^{
                                     v.alpha = 0.0f;
                                 } completion:^(BOOL finished) {
                                     [v removeFromSuperview];
                                 }];
            }
            
            // otherwise, just remove it from the superview
            else {
                [v removeFromSuperview];
            }
            
            
        }
    }
    
}

@end
