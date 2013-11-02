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

#import "KTAlert.h"

#import "KTAlertToast.h"
#import "KTAlertBar.h"
#import "KTUtilities.h"

#import <QuartzCore/QuartzCore.h>

/*
 Set some pre-defined constants
 */
#define KTAlertFadeDuration         0.5

@interface KTAlert() {
    KTAlertType _type;
    NSUInteger _duration;
}

- (void) configure;

@end

@implementation KTAlert

#pragma mark - Subclass stubs
/* Stubbed.. should be overriden by subclasses */
- (void) configure { }

#pragma mark - Initialization methods
- (KTAlert*) initWithType:(KTAlertType)type
              withMessage:(NSString*)message
              andDuration:(NSUInteger)durationInMillis
{

    // figure out which type to show and create it accordingly
    if(type == KTAlertTypeToast) {
        self = [[KTAlertToast alloc] init];
    } else if(type == KTAlertTypeBar) {
        self = [[KTAlertBar alloc] init];
    }
    
    if(self) {
        
        // set the instance variables
        _message = message;
        _type = type;
        _duration = durationInMillis;
        
        // configure based on the type
        if([self isKindOfClass:[KTAlertToast class]]) {
            [(KTAlertToast*)self configure];
        } else if([self isKindOfClass:[KTAlertBar class]]) {
            [(KTAlertBar*)self configure];
        }

        // add 'tap to dismiss'
        // todo: make customizable
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
                
    }
    
    return self;
}

#pragma mark - Display methods
- (void) show
{
    
    // hide any existing alerts
    // TODO: stack alerts
    [KTAlert hideAlerts];
    
    // add the toast to the root window (so it overlays everything)
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    
    // set up the fade-in
    // todo: customize animation
    // todo: handle this by subclass
    [UIView animateWithDuration:KTAlertFadeDuration/2
                     animations:^{
                         
                         // if it's a bar, slide it in from the top of the screen
                         if(_type == KTAlertTypeBar) {
                             
                             CGRect f = self.frame;
                             
                             BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
                             f.origin.y = (statusBarHidden || [KTDevice isIOS7orLater]) ? 0.0f : ktStatusBarHeight;
                             
                             self.frame = f;
                         }
                         
                         // if it's a toast, fade it in
                         else if(_type == KTAlertTypeToast) {
                             self.alpha = 1.0f;
                         }
                         
                     }
     
                     completion:^(BOOL finished) {
                         
                         // if the duration is not persistent (should auto-hide)
                         if(_duration > KTAlertDurationPersistent) {
                             
                             // set a timeout to remove the alert from view after a certain time
                             CGFloat seconds = _duration / 1000;
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                                 [self dismiss];                                 
                             });
                         }
                         
                     }];

}

- (void) dismiss
{
    
    // set up an animation to hide the alert from view
    // todo: handle this by subclass
    [UIView animateWithDuration:KTAlertFadeDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         // if it's a bar, slide it out to the top of the screen
                         if(_type == KTAlertTypeBar) {
                             CGRect f = self.frame;
                             f.origin.y = -1 * self.frame.size.height;
                             self.frame = f;
                         }
                         
                         // if it's a toast, fade it out
                         else if(_type == KTAlertTypeToast) {
                             self.alpha = 0.0f;
                         }
                         
                     }
     
                     // once complete, remove the alert from the view
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];

}

#pragma mark - Static creation / display methods
+ (void) showAlert:(KTAlertType)type
       withMessage:(NSString*)message
       andDuration:(NSUInteger)durationInMillis
{
    
    // build the alert object
    KTAlert *alert = [[KTAlert alloc] initWithType:type
                                       withMessage:message
                                       andDuration:durationInMillis];
    
    // show it
    [alert show];
}

+ (void) showPersistentAlert:(KTAlertType)type
                 withMessage:(NSString*)message
{
    
    // pre-fill duration to persistent and send to convenience method
    [KTAlert showAlert:type
           withMessage:message
           andDuration:KTAlertDurationPersistent];
}

+ (void) hideAlerts
{
    
    // iterate through all subviews of the window (top-level)
    for(UIView *v in [[[UIApplication sharedApplication] keyWindow] subviews]) {
        
        // if it's a KTAlert object, remove it from the view
        if([v isKindOfClass:[KTAlert class]]) {
            [v removeFromSuperview];
        }
    }
    
}



@end
