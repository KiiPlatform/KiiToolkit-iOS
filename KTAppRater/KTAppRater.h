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

#import <Foundation/Foundation.h>

/**
 Add a rating mechanism to your app with 2 lines of code with this class. Fully customizable and configurable via easy static methods, prompt your users for a 5-star rating in the app store after a set period of time or number of app opens. See the wiki in our GitHub page for examples https://github.com/KiiPlatform/KiiToolkit-iOS/wiki
 */
@interface KTAppRater : NSObject

#pragma mark Configuration

/**
 A mandatory method call, this sets up KTAppRater for your app
 
 @param appId The numeric application ID for your app, assigned by iTunes and can be found in your app's page on iTunes Connect
 */
+ (void) configureAppID:(NSString*)appId;

/**
 Set the number of days that must pass between the app's first open and when the rating prompt is shown
 
 @param minimumDays The minimum number of days that must pass. Default = 5, set to -1 for no minimum (i.e. will disregard this parameter)
 */
+ (void) setMinimumDaysBeforeDisplay:(int)minimumDays;

/**
 Set the number of app opens that must pass between the app's first open and when the rating prompt is shown
 
 @param minimumUses The minimum number of uses or opens that must pass. Default = 10, set to -1 for no minimum (i.e. will disregard this parameter)
 */
+ (void) setMinimumUsesBeforeDisplay:(int)minimumUses;

/**
 Set the number of days that must pass from when the 'Remind me later' button is tapped and when the rating prompt is shown again
 
 @param daysBeforeReminding The number of days that must pass. Default = 2, set to -1 for no minimum (i.e. will disregard this parameter)
 */
+ (void) setDaysBeforeReminding:(int)daysBeforeReminding;


/**
 Set the alert title that should be shown to the user
 
 @param alertTitle The alert title. Default = "Rate {{APP_NAME}}!". In the default, {{APP_NAME}} is replaced by your app's display name.
 */
+ (void) setAlertTitle:(NSString*)alertTitle;

/**
 Set the alert message that should be shown to the user
 
 @param alertMessage The alert message. Default = "Thanks for using {{APP_NAME}}! If you enjoy it, would you mind giving it a 5-star rating on the app store? We'd really appreciate it!". In the default, {{APP_NAME}} is replaced by your app's display name.
 */
+ (void) setAlertMessage:(NSString*)alertMessage;


/**
 Set the label for the 'rate now' button that is shown to the user
 
 @param alertRateNowButtonTitle The rate now button title. Default = "Rate it now!"
 */
+ (void) setAlertRateNowButtonTitle:(NSString*)alertRateNowButtonTitle;

/**
 Set the label for the reminder button that is shown to the user
 
 @param alertReminderButtonTitle The reminder button title. Default = "Remind me later"
 */
+ (void) setAlertReminderButtonTitle:(NSString*)alertReminderButtonTitle;

/**
 Set the label for the decline button that is shown to the user
 
 @param alertDeclineButtonTitle The decline button title. Default = "No, thanks"
 */
+ (void) setAlertDeclineButtonTitle:(NSString*)alertDeclineButtonTitle;

#pragma mark Actions

/**
 This method should be called when your app is opened. If the conditions are met, the prompt will be shown here
 */
+ (void) appOpened;

@end
