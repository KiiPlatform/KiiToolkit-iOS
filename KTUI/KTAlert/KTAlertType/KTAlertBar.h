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

#import "KTAlert.h"

/**
 A subclass of KTAlert which displays a one-line text bar at the top of the screen, overlaying all other views. This maps to the type KTAlertTypeBar.
 */
@interface KTAlertBar : KTAlert

/**
 Set a custom background color (or gradient) for the alert bar
 
 This will override the default red gradient background
 
 @param color A nil-terminated list of UIColor objects for the background gradient. Can be any number of colors (0=clear, 1=solid color, N=gradient). The fill is from top to bottom
 */
- (void) setBackgroundColors:(UIColor*)color, ... NS_REQUIRES_NIL_TERMINATION;

@end
