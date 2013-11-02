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

// some global definitions that are nice to have nearby :)
#define ktStatusBarHeight       20.0f
#define ktIphone5Difference     88.0f
#define ktIphoneHeight          480.0f
#define ktIphone5Height         ktIphoneHeight + ktIphone5Difference

/**
 A set of definitions and convenience methods to make device management easier
 */
@interface KTDevice : NSObject

/**
 Determines whether or not the device is running iOS7 or later
 
 Useful for knowing if adjustments are needed for iOS7
 
 @return TRUE if iOS7 or above
 */
+ (BOOL) isIOS7orLater;

/**
 Determines whether or not the device is an iPhone or iPod Touch
 
 @return TRUE if iPhone or iPod Touch
 */
+ (BOOL) isIphone;

/**
 Determines whether or not the device is an iPad
 
 @return TRUE if iPad
 */
+ (BOOL) isIpad;

/**
 Determines whether or not the device is an iPhone with a 4-inch screen
 
 This is useful for making UI adjustments based on device. The 4-inch screen is currently the iPhone 5 and above.
 
 @return TRUE if iPhone with 4-inch screen
 */
+ (BOOL) isFourInchIphone;

@end
