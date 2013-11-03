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

@class KTTextField, KTButton, KTLoginViewController;

/**
 Created and called by the KTLoginViewController, this view handles all the logic and UI for resetting a forgotten password. As with the other view controllers, this view can be customized fully. To access this view easily from your application's class, do something like:
 
        
    KTLoginViewController *vc = [[KTLoginViewController alloc] init];
 
    KTForgotPasswordViewController *fpvc = vc.forgotPasswordView;
        // customize here
        ...
 
    [self presentViewController:vc animated:TRUE completion:nil];

 
 */
@interface KTForgotPasswordViewController : UIViewController <UITextFieldDelegate>

/** The associated KTLoginViewController */
@property (nonatomic, strong) KTLoginViewController *loginViewController;

/** The title image (defaults to Kii logo) */
@property (nonatomic, strong) UIImageView *titleImage;

/** The background image */
@property (nonatomic, strong) UIImageView *backgroundImage;

/** The user identifier text field */
@property (nonatomic, strong) KTTextField *userIdentifierField;

/** The action button to reset the password */
@property (nonatomic, strong) KTButton *sendResetButton;

/** Give the user the opportunity to close the view. Hide this if the user must be authenticated */
@property (nonatomic, strong) UIButton *closeButton;

@end
