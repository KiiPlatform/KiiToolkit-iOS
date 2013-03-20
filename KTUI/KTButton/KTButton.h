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

/**
 A subclassed UIButton with some UI improvements
 */
// TODO: make attributes customizable
@interface KTButton : UIButton

/** Set the border color for the button. Defaults to the lower gradient color, or clear if no colors set */
@property (nonatomic, strong) UIColor *borderColor;

/**
 Create a KTButton with a nice looking, graphic-free background
 
 @param frame The frame of the button within its parent view
 @param colors A nil-terminated list of UIColor objects for the background gradient. Can be any number of colors (0=clear, 1=solid color, N=gradient). The fill is from top to bottom
 */
- (id)initWithFrame:(CGRect)frame
  andGradientColors:(UIColor*)colors, ... NS_REQUIRES_NIL_TERMINATION;

/**
 Set the gradient background colors
 
 @param colors A nil-terminated list of UIColor objects for the background gradient. Can be any number of colors (0=clear, 1=solid color, N=gradient). The fill is from top to bottom
 */
- (void) setGradientColors:(UIColor*)colors, ... NS_REQUIRES_NIL_TERMINATION;

@end
