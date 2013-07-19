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

#import <UIKit/UIKit.h>

// Some default constants
#define KTAlertDurationShort        1000
#define KTAlertDurationLong         3000
#define KTAlertDurationPersistent   0

/**
 The types of alerts available to display. Each have different attributes and styles, so be sure to check out their subclasses for full customization.
 */
enum {
    /* See KTAlertToast */
    KTAlertTypeToast    = 1,

    /* See KTAlertBar */
    KTAlertTypeBar      = 2
};
typedef NSUInteger KTAlertType;


/**
 A UI element that displays an alert to the user. Differing from UIAlertView, this class is meant to show nice-looking and/or more subtle, less invasive alerts.
 */
@interface KTAlert : UIView

@property (nonatomic, strong) NSString *message;

#pragma mark - Public Static Methods

/**
 Shows an alert with a given type, message and duration
 
 @param type The type of alert to display. See KTAlertType and KTAlert subclasses for full descriptions
 @param message The message to display to the user. Depending on the type, be careful of the message length - it may be truncated in some alert types
 @param durationInMillis How long to show the alert. Set to 0 for a persistent alert that you remove manually
 */
+ (void) showAlert:(KTAlertType)type
       withMessage:(NSString*)message
       andDuration:(NSUInteger)durationInMillis;


/**
 Shows a persistent alert with a given type and message
 
 You may wish to use a persistent message if you are showing the alert while an action takes place for an unknown time
 
 @param type The type of alert to display. See KTAlertType and KTAlert subclasses for full descriptions
 @param message The message to display to the user. Depending on the type, be careful of the message length - it may be truncated in some alert types
 */
+ (void) showPersistentAlert:(KTAlertType)type
                 withMessage:(NSString*)message;


/** 
 Called at any time, this method will remove all alerts from view
 */
+ (void) hideAlerts;

#pragma mark - Public Instance Methods

/**
 Create a KTAlert UI element
 
 Use this method if you wish to customize and show manually. Otherwise, try the static methods for easier use.
 
 @param type The type of alert to display. See KTAlertType and KTAlert subclasses for full descriptions
 @param message The message to display to the user. Depending on the type, be careful of the message length - it may be truncated in some alert types
 @param durationInMillis How long to show the alert. Set to 0 for a persistent alert that you remove manually
 */
- (KTAlert*) initWithType:(KTAlertType)type
              withMessage:(NSString*)message
              andDuration:(NSUInteger)durationInMillis;

/**
 Manually show your KTAlert element
 */
- (void) show;

/**
 Manually remove your KTAlert element from the view
 */
- (void) dismiss;

@end
