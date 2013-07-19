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

#import "KTRegistrationViewController.h"
#import "KTForgotPasswordViewController.h"

@class KTTextField, KTButton;
@class KTRegistrationViewController, KTForgotPasswordViewController;

/**
 This class is a ViewController which allows you to create a full user authentication experience with only 2 lines of code: initialization and showing the view controller:
 
    KTLoginViewController *vc = [[KTLoginViewController alloc] init];
    [self presentViewController:vc animated:TRUE completion:nil];

 Included is: user authentication, user registration, and a forgotten password view. All the UI interactions, successes and failures are handled via the KiiToolkit classes. All views can be customized, including layout, graphics and text - so you can make the view your own without having to worry about the user logic.
 
 A good way to get the authenticated user is from your view controller which calls the presentViewController - in its viewDidAppear: method. You can access the user using:
 
    KiiUser *user = [KiiUser currentUser];

 */
@interface KTLoginViewController : UIViewController <UITextFieldDelegate>

/** The title image (defaults to Kii logo) */
@property (nonatomic, strong) UIImageView *titleImage;

/** The background image */
@property (nonatomic, strong) UIImageView *backgroundImage;

/** The username field within the login view */
@property (nonatomic, strong) KTTextField *usernameField;

/** The password field within the login view */
@property (nonatomic, strong) KTTextField *passwordField;

/** The button which initiates the authentication */
@property (nonatomic, strong) KTButton *loginButton;

/** The registration button. Sends the user to the registration view */
@property (nonatomic, strong) KTButton *registerButton;

/** The 'forgot password' button */
@property (nonatomic, strong) UIButton *forgotButton;
 
/** Give the user the opportunity to close the view. Hide this if the user must be authenticated */
@property (nonatomic, strong) UIButton *closeButton;

/** The descriptive label letting the user know they can register if they have no account yet. Default is located directly above registration button */
@property (nonatomic, strong) UILabel *noAccountLabel;

/** The registration view controller as a property, in order to customize it from a single access point after the KTLoginViewController is initiated */
@property (nonatomic, strong) KTRegistrationViewController *registrationView;

/** The forgot password view controller as a property, in order to customize it from a single access point after the KTLoginViewController is initiated */
@property (nonatomic, strong) KTForgotPasswordViewController *forgotPasswordView;

@end
