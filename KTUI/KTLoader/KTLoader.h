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
 This class is made for conveniently showing a full-screen loader and not allowing the UI to be interacted with. This is useful when your application is performing an asynchronous operation and the user must wait for completion before continuing their interaction
 */
@interface KTLoader : UIView

#pragma mark - Public Static Methods

/**
 Show a loader with a given message and animate in/out option
 
 @param message The one-line message to display to the user within the loader
 @param animated TRUE if the view should animate in, FALSE otherwise
 */
+ (void) showLoader:(NSString*)message animated:(BOOL)animated;

/**
 Hide any loader that is currently on the screen with an animation option
 
 @param animated TRUE if the view should animate out, FALSE otherwise
 */
+ (void) hideLoader:(BOOL)animated;

@end
