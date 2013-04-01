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
 Utility methods for UIColor to make common functionality
 more efficient and reusable.
 */
@interface UIColor (KTUtilities)

/** 
 Create a UIColor object via a hex string
 
 The string can be 3, 6 or 8 characters (which also may be prepended by 0x). 
 3 character strings represent the format RGB
 6 character strings represent the format RRGGBB
 8 character strings represent the format RRGGBBAA where AA is alpha (opacity)
 
 Unless specified by an 8 character string, alpha will default to fully opaque (0xFF)
 
 @param hex The hexadecimal string representation of the desired color
 @return a UIColor object representing the given hex string. If unable to parse, the default return color is black
 */
+ (UIColor*) colorWithHex:(NSString*)hex;

/**
 Generates a random color
 
 @return a UIColor object with a random value
 */
+ (UIColor*) randomColor;

@end
