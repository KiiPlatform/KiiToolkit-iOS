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
 Utility methods for NSMutableArray to make common functionality more efficient and reusable.
 */
@interface UILabel (KTUtilities)

/**
 Get the expected width of a label
 
 This can be useful for automatically sizing label objects horizontally when they have a known height, font and linebreak mode.

 @return The expected width of the label
 */
- (CGFloat) expectedWidth;

@end
