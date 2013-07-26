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
    KTProgressIndicatorTypeBarDefault,
    KTProgressIndicatorTypeCircular
};
typedef NSInteger KTProgressIndicatorType;

/**
 A UI element that displays a progress bar. This class will be skinnable with a few default types to get you started. It is meant to be a nicer-looking, more customizable solution to the standard iOS UIProgressView
 */
@interface KTProgressIndicator : UIView

/** The current progress value of the bar [0, 1] **/
@property (nonatomic, assign) double progress;

/** The inside view (the actual progress bar, inside the container) */
@property (nonatomic, strong) UIView *subProgressView;

/** Applicable only to the KTProgressBarType KTProgressBarTypeCircular, access this object to update the parameters (colors, etc) of the progress indicator */
@property (nonatomic, strong) KTCircularProgressIndicator *circularProgressIndicator;

/**
 Set the progress with bar growth animation
 
 This method should be called if you don't wish to have animation with the standard progress property (or setProgress: method call), as the animation default is usually TRUE
 @param progress The value [0,1] to set the progress bar to
 @param animated TRUE if the progress bar should 'grow' with animation. FALSE otherwise
 */
- (void) setProgress:(double)progress
            animated:(BOOL)animated;

/** 
 Create a KTProgressBar with the default type (KTProgressBarTypeBarDefault)
 
 If you want to customize the progress bar type, use the initWithFrame:andType: method
 
 @param frame The frame that should be used by the KTProgressBar
 @return The KTProgressBar object
 */
- (id) initWithFrame:(CGRect)frame;

/**
 Create a KTProgressBar with the default type (KTProgressBarTypeBarDefault)
 
 @param frame The frame that should be used by the KTProgressBar
 @param type The KTProgressBarType to use for this indicator
 @return The KTProgressBar object
 */
- (id) initWithFrame:(CGRect)frame
             andType:(KTProgressIndicatorType)type;

@end
