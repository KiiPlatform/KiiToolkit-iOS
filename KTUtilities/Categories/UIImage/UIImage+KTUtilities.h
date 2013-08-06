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
 Utility methods for NSString to make commonly-needed functionality more efficient and reusable.
 */
@interface UIImage (KTUtilities)

/**
 A resize method for UIImage, this will use the 'scale-to-fill' method of scaling. i.e. the image will be trimmed in order to completely fill the newSize.
 
 @param image The original image which you'd like to scale
 @param newSize The constrained size you'd like the image scaled to
 @return A UIImage object with the scaled image
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
