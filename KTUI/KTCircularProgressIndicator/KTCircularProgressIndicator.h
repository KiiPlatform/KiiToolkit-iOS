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
 A code-controlled visual element to signify progress. We sometimes refer to this as a 'pie' loader
 */
@interface KTCircularProgressIndicator : UIView

/** The progress amount to use from [0,1] with 1 being a 'full pie' */
@property (nonatomic, assign) double progress;

/** The stroke color of the 'pie' - default is [UIColor whiteColor] */
@property (nonatomic, strong) UIColor *strokeColor;

/** The fill color of the 'pie' - default is [UIColor whiteColor] */
@property (nonatomic, strong) UIColor *fillColor;

@end
