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
 A subclassed UITextField with some UI improvements
 */
@interface KTTextField : UITextField

/** Set the border color for the textview (defaults to [UIColor clearColor]) */
@property (nonatomic, strong) UIColor *borderColor;

/** Set to TRUE if the text field should glow when being edited, FALSE otherwise */
@property (nonatomic, assign) BOOL glows;

/**
 Create the text field with some pre-defined attributes
  
 @param frame The desired frame of the object within its parent view
 @param borderColor The border color of the text view
 @param glows TRUE if the text field should emit an outer glow when being edited, FALSE otherwise
 */
+ (KTTextField*) textFieldWithFrame:(CGRect)frame
                     andBorderColor:(UIColor*)borderColor
                           andGlows:(BOOL)glows;

@end
