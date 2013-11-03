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
 The field types that can be shown to the user for registration. The default field is KTRegistrationFieldLoginName (username), and at least one of KTRegistrationFieldLoginName, KTRegistrationFieldEmailAddress or KTRegistrationFieldPhoneNumber must be included. These fields can be set in the display by using the displayFields property of the class instance.
 */
enum {
    /** The user's login name (username) */
    KTRegistrationFieldLoginName        = 1,

    /** The user's email address */
    KTRegistrationFieldEmailAddress     = 2,

    /** The user's phone number */
    KTRegistrationFieldPhoneNumber      = 4,
    
    /** The user's display name */
    KTRegistrationFieldDisplayName      = 8
};
typedef NSUInteger KTRegistrationFields;

@class KTTextField, KTButton, KTLoginViewController;

/**
 Created and called by the KTLoginViewController, this view handles all the logic and UI for registering a user. As with the other view controllers, this view can be customized fully - including which text fields are displayed to the user. To access this view easily from your application's class, do something like:
 
 
    KTLoginViewController *vc = [[KTLoginViewController alloc] init];
         
    KTRegistrationViewController *rvc = vc.registrationView;
        // customize here
        ...
         
    [self presentViewController:vc animated:TRUE completion:nil];
 
 
 */
@interface KTRegistrationViewController : UIViewController <UITextFieldDelegate>

/** The associated KTLoginViewController */
@property (nonatomic, strong) KTLoginViewController *loginViewController;

/** The title image (defaults to Kii logo) */
@property (nonatomic, strong) UIImageView *titleImage;

/** The background image */
@property (nonatomic, strong) UIImageView *backgroundImage;

/** The login name input text field (default: displayed) */
@property (nonatomic, strong) KTTextField *loginNameField;

/** The email address input text field (default: not displayed) */
@property (nonatomic, strong) KTTextField *emailAddressField;

/** The display name input text field (default: not displayed) */
@property (nonatomic, strong) KTTextField *displayNameField;

/** The phone number input text field (default: not displayed) */
@property (nonatomic, strong) KTTextField *phoneNumberField;

/** The password input text field (default: displayed) */
@property (nonatomic, strong) KTTextField *passwordField;

/** The action button to initiate the registration */
@property (nonatomic, strong) KTButton *registerButton;

/** Give the user the opportunity to close the view. Hide this if the user must be authenticated */
@property (nonatomic, strong) UIButton *closeButton;

/** Set the text fields to display to the user. Pipe together all KTRegistrationFields you'd like to show. Note that password will always be shown.
 Example:
        registrationView.displayFields = KTRegistrationFieldLoginName | KTRegistrationFieldEmailAddress
 */
@property (nonatomic, assign) NSUInteger displayFields;


/**
 This method will add a Facebook authentication button to your RegistrationViewController
 
 Simply call this method if you wish to use Facebook registration within your app. If you wish to allow authentication with Facebook (i.e. log in), then call the method useFacebookAuthenticationOption on the KTLoginViewController
 
 > Note: There is some setup required to utilize Facebook. See instructions [here](http://documentation.kii.com/en/guides/ios/managing-users/social-network-integration/facebook-integration/)
 */
- (void) useFacebookRegistrationOption;

/**
 This method will add a Twitter authentication button to your RegistrationViewController
 
 Simply call this method if you wish to use Twitter registration within your app. If you wish to allow authentication with Twitter (i.e. log in), then call the method useTwitterAuthenticationOption on the KTLoginViewController
 
 > Note: There is some setup required to utilize Twitter. See instructions [here](http://documentation.kii.com/en/guides/ios/managing-users/social-network-integration/twitter-integration/)
 
 @param twitterKey Your app's Twitter Consumer Key
 @param twitterSecret Your app's Twitter Consumer Secret
 */
- (void) useTwitterRegistrationOption:(NSString*)twitterKey
                            andSecret:(NSString*)twitterSecret;

@end
