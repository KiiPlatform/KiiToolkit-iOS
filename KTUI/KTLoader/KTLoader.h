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

@class KTCircularProgressIndicator;

enum {
    KTLoaderIndicatorSpinner,
    KTLoaderIndicatorSuccess,
    KTLoaderIndicatorError,
    KTLoaderIndicatorProgress
};
typedef NSInteger KTLoaderIndicatorType;

enum {
    KTLoaderDurationIndefinite = 0,
    KTLoaderDurationAuto = 3000
};
typedef NSUInteger KTLoaderIndicatorDuration;

/** 
 This class is made for conveniently showing a loading indicator that does not allow the UI to be interacted with. This is useful when your application is performing an asynchronous operation and the user must wait for completion before continuing their interaction
 */
@interface KTLoader : UIView

#pragma mark - Public Static Methods

/**
 Show a loader with a given message and default extra options. This is the most basic method call available.
 
 @param message The one-line message to display to the user within the loader
 */
+ (void) showLoader:(NSString*)message;

/**
 Show a loader with a given message and animate in/out option, the extra options are set to default
 
 @param message The one-line message to display to the user within the loader
 @param animated TRUE if the view should animate in, FALSE otherwise
 */
+ (void) showLoader:(NSString*)message
           animated:(BOOL)animated;

/**
 Show a loader with a given message, animate in/out option and indicator type. The duration is set to default
 
 @param message The one-line message to display to the user within the loader
 @param animated TRUE if the view should animate in, FALSE otherwise
 @param indicator One of the KTLoaderIndicatorType options to be displayed within the loader
 */
+ (void) showLoader:(NSString*)message
           animated:(BOOL)animated
      withIndicator:(KTLoaderIndicatorType)indicator;


/**
 Show a loader with a given message, animate in/out option and indicator type. The duration is set to default
 
 @param message The one-line message to display to the user within the loader
 @param animated TRUE if the view should animate in, FALSE otherwise
 @param indicator One of the KTLoaderIndicatorType options to be displayed within the loader
 @param hideInterval Can either be one of the KTLoaderIndicatorDuration options or an integer representing milliseconds
 */
+ (void) showLoader:(NSString*)message
           animated:(BOOL)animated
      withIndicator:(KTLoaderIndicatorType)indicator
    andHideInterval:(KTLoaderIndicatorDuration)hideInterval;

/**
 Hide the loader that is currently on the screen with the default animation type
*/
+ (void) hideLoader;

/**
 Hide any loader that is currently on the screen with an animation option
 
 @param animated TRUE if the view should animate out, FALSE otherwise
 */
+ (void) hideLoader:(BOOL)animated;

/**
 Applicable only to the KTLoaderIndicatorType KTLoaderIndicatorProgress, this will show a circular loader with progress
 
 @param progress A value from [0,1] that indicates the progress
 */
+ (void) setProgress:(double)progress;

/** Applicable only to the KTLoaderIndicatorType KTLoaderIndicatorProgress, access this object to update the parameters (colors, etc) of the progress indicator */
+ (KTCircularProgressIndicator*)progressIndicator;

@end
