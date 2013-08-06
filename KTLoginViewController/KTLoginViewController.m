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

#import "KiiToolkit.h"

#if __has_include(<KiiSDK/Kii.h>)

#import <KiiSDK/Kii.h>
#import <QuartzCore/QuartzCore.h>

@interface KTLoginViewController () {
    CGFloat _originalY;
}

- (void) shiftView:(UITextField*)textField;

@end

@implementation KTLoginViewController

#pragma mark - Action methods

- (void) performAuthentication:(id)sender
{

    // hide the keyboard and re-frame the view
    [self tappedView];

    // Get the user identifier/password from the UI
    NSString *userIdentifier = [_usernameField text];
    NSString *password = [_passwordField text];

    // show a loading screen to the user
    [KTLoader showLoader:@"Logging in..." animated:TRUE];
    
    // perform the asynchronous authentication
    [KiiUser authenticate:userIdentifier
             withPassword:password
                 andBlock:^(KiiUser *user, NSError *error) {
                     
                     // authentication was successful
                     if(error == nil) {
                         
                         [KTLoader showLoader:@"Logged In!"
                                     animated:TRUE
                                withIndicator:KTLoaderIndicatorSuccess
                              andHideInterval:KTLoaderDurationAuto];

                         // hide this view and go back to the app
                         [self dismissViewControllerAnimated:TRUE completion:nil];
                     }
                     
                     // authentication failed
                     else {

                         // tell the user
                         [KTAlert showAlert:KTAlertTypeBar
                                withMessage:@"Unable to log in - verify your credentials"
                                andDuration:KTAlertDurationLong];
                         
                         // tell the console with a more descriptive error
                         NSLog(@"Error creating object: %@", error.description);
                         
                         // the authentication is complete, hide the loading view
                         [KTLoader hideLoader:TRUE];
                     }
                     
                 }];
    
    
}

- (void) showForgotPassword:(id)sender
{
    // create and display the 'forgot password' screen as a new modal view
    [self presentViewController:_forgotPasswordView animated:TRUE completion:nil];
}

- (void) showRegistration:(id)sender
{
    // create and display the registration screen as a new modal view
    [self presentViewController:_registrationView animated:TRUE completion:nil];
}

// the user clicked the 'close' button
- (void) closeView:(id)sender
{
    // close the view
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

// called when the user has tapped the background view.
// made so the keyboard will disappear when the user wants to hide it and go back to the view
- (void) tappedView
{
    
    // hide the keyboard
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    
    // return the view to its proper position
    [self shiftView:nil];
}

// this method is called when the textfields are brought in or
// removed from focus. it will shift the view such that the textfield
// is nicely centered and not hidden by the keyboard
- (void) shiftView:(UITextField*)textField
{
    
    CGRect frame = CGRectZero;
    
    // if the textfield is not nil, that means we're not force-hiding
    if(textField != nil) {
        
        // get the coordinates of the view and the maximum Y origin component we will allow
        CGFloat offset = textField.frame.origin.y + textField.frame.size.height + KT_KEYBOARD_PADDING_HEIGHT;
        CGFloat maximum = self.view.frame.size.height - KT_KEYBOARD_HEIGHT;
        
        // the view would be hidden or not in acceptable range, we need to slide the view
        if(offset > maximum) {
            
            // set the frame to a safe, centered position
            frame = self.view.frame;
            frame.origin.y = maximum - offset;
            
        }
        
    }
    
    // if the view hasn't been changed so far - it needs to be moved back to its default position
    if(CGRectEqualToRect(frame, CGRectZero) && self.view.frame.origin.y != _originalY) {
        frame = self.view.frame;
        frame.origin.y = _originalY;
    }
    
    // if there was a change made, make it a nice animated change
    if(!CGRectEqualToRect(frame, CGRectZero)) {
        
        // perform the animation
        [UIView animateWithDuration:KT_KEYBOARD_ANIMATION_TIME
                         animations:^{
                             self.view.frame = frame;
                         }];
        
    }
    
}

#pragma mark - Initialization methods

- (id) init
{
    
    self = [super init];
    
    if(self) {
        
        // store the origin for later use
        _originalY = self.view.frame.origin.y;
        
        // initialize the registration + forgot password views for access
        _registrationView = [[KTRegistrationViewController alloc] init];
        _forgotPasswordView = [[KTForgotPasswordViewController alloc] init];
        
        // and set our default background color (matched to background image)
        self.view.backgroundColor = [UIColor colorWithWhite:0.76470588235f alpha:1.0f];
        
        // this image is a light gradient that blends in with the background
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        _backgroundImage.image = [UIImage imageNamed:@"kt_login_bg"];
        _backgroundImage.contentMode = UIViewContentModeTopLeft;
        [self.view addSubview:_backgroundImage];
        
        
        
        // create and add the close button
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0, 0, 48, 48);
        _closeButton.backgroundColor = [UIColor clearColor];
        [_closeButton setImage:[UIImage imageNamed:@"kt_login_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeButton];
        
        
        
        // create and add the title image (defaults to Kii logo)
        _titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kt_login_kii_logo"]];
        _titleImage.contentMode = UIViewContentModeCenter;
        _titleImage.clipsToBounds = FALSE;
        _titleImage.frame = CGRectMake(20, 30, 280, 70);
        [self.view addSubview:_titleImage];
        
        
        // set the default size/offset for our text fields
        CGFloat xOffset = 28;
        CGFloat width = 320 - xOffset*2;
        
        // create the colors to use for our text field borders and button gradients
        UIColor *darkOrange = [UIColor colorWithHex:@"D27422"];
        UIColor *lightOrange = [UIColor colorWithHex:@"F89743"];
        UIColor *darkGreen = [UIColor colorWithHex:@"005404"];
        UIColor *lightGreen = [UIColor colorWithHex:@"009C00"];
        
        
        // create and add the username field
        _usernameField = [KTTextField textFieldWithFrame:CGRectMake(xOffset, 100, width, 40)
                                          andBorderColor:lightOrange
                                                andGlows:TRUE];
        _usernameField.delegate = self;
        _usernameField.placeholder = @"Username, email or phone number";
        _usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _usernameField.returnKeyType = UIReturnKeyNext;
        [self.view addSubview:_usernameField];
        
        
        // create and add the password field
        _passwordField = [KTTextField textFieldWithFrame:CGRectMake(xOffset, 154, width, 40)
                                          andBorderColor:lightOrange
                                                andGlows:TRUE];
        _passwordField.delegate = self;
        _passwordField.placeholder = @"Enter your password";
        _passwordField.secureTextEntry = TRUE;
        _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordField.returnKeyType = UIReturnKeyDone;
        [self.view addSubview:_passwordField];
        
        
        
        // create and add the login button
        _loginButton = [[KTButton alloc] initWithFrame:CGRectMake(xOffset, 208, width, 45)
                                     andGradientColors:lightOrange, darkOrange, nil];
        
        [_loginButton setTitle:@"Log In" forState:UIControlStateNormal];
        [self.view addSubview:_loginButton];
        [_loginButton addTarget:self action:@selector(performAuthentication:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        // create and add the forgot password button
        _forgotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgotButton.frame = CGRectMake(76, self.view.frame.size.height-38-20, 167, 38);
        _forgotButton.backgroundColor = [UIColor colorWithWhite:(164.0f/255.0f) alpha:1.0f];
        _forgotButton.clipsToBounds = TRUE;
        _forgotButton.layer.cornerRadius = 6.0f;
        _forgotButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_forgotButton setTitleColor:[UIColor colorWithWhite:(109.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
        [_forgotButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
        [_forgotButton addTarget:self action:@selector(showForgotPassword:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_forgotButton];
        
        
        
        
        // put the 'no account yet?' label halfway between login and registration button
        CGFloat totalHeight = 18 + 45;
        CGFloat loginEnd = _loginButton.frame.origin.y + _loginButton.frame.size.height;
        CGFloat diff = _forgotButton.frame.origin.y - loginEnd;
        
        int offset = (diff - totalHeight) / 2;
        
        // create the 'no account yet?' label and add it to the view
        _noAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, loginEnd + offset, width, 14)];
        _noAccountLabel.text = @"Not a member yet?";
        _noAccountLabel.backgroundColor = [UIColor clearColor];
        _noAccountLabel.textAlignment = NSTextAlignmentCenter;
        _noAccountLabel.font = [UIFont systemFontOfSize:14.0f];
        _noAccountLabel.textColor = [UIColor colorWithWhite:(101.0f/255.0f) alpha:1.0f];
        [self.view addSubview:_noAccountLabel];
        
        
        // create and add the registration button
        _registerButton = [[KTButton alloc] initWithFrame:CGRectMake(xOffset, _noAccountLabel.frame.origin.y+18, width, 45)
                                        andGradientColors:lightGreen, darkGreen, nil];
        
        [_registerButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        [self.view addSubview:_registerButton];
        [_registerButton addTarget:self action:@selector(showRegistration:) forControlEvents:UIControlEventTouchUpInside];
        
        
        // we want to hide the keyboard when the user taps the background, so create and add the recognizer here
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView)];
        [self.view addGestureRecognizer:tap];
        
    }
    
    return self;
}


#pragma mark - View methods
- (void) viewDidAppear:(BOOL)animated {
    
    // check if this user is already logged in
    if([KiiUser loggedIn]) {
        
        // if they are, hide this view
        [self dismissViewControllerAnimated:TRUE completion:nil];
        
    }
    
}


#pragma mark - UITextField delegate methods

// one of the textfields is being edited
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    // shift the view (if needed) so the textview is fully visible
    [self shiftView:textField];
}

// the user has hit the 'next' or 'done' button
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    // if from the username field, it was a 'next' button
    if([textField isEqual:_usernameField]) {
        
        // so move focus to the password field
        [_passwordField becomeFirstResponder];
    }
    
    // otherwise, it was the password field
    else {
        
        // so hide the keyboard
        [_passwordField resignFirstResponder];
        
        // also, slide the view down (if needed)
        [self shiftView:nil];
    }
    
    return FALSE;
}


@end

#endif