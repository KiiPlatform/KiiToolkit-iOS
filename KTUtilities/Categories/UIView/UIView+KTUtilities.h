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
 Utility methods for UIView to make common functionality
 more efficient and reusable.
 */
@interface UIView (KTUtilities)


/**
 Ensure a view is not blurry by residing on pixel fractions
 
 In some cases, when a view's frame is modified by its 'center' attribute, the view's origin may end up on a half pixel (ex: x=132.5). This method simply rounds the origin to the nearest whole pixels to ensure the view is not blurred by its position.
 
 This may be integrated more deeply if the setCenter: method is ever overriden
 */
- (void) normalizeView;

@end
