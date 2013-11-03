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
#import <Accounts/Accounts.h>

@interface KTLoginViewController () {
    KTButton *_facebookButton;
    KTButton *_twitterButton;
}

- (void) shiftView:(UITextField*)textField;

@end

@implementation KTLoginViewController

- (void) authComplete:(KiiUser*)user withError:(NSError*)error
{
    // authentication was successful
    if(error == nil) {
        
        if(_shouldHandleDialogs) {
            [KTLoader showLoader:@"Logged In!"
                        animated:TRUE
                   withIndicator:KTLoaderIndicatorSuccess
                 andHideInterval:KTLoaderDurationAuto];
        }
        
        // hide this view and go back to the app
        [self dismissViewControllerAnimated:TRUE completion:nil];
    }
    
    // authentication failed
    else {
        
        // tell the console with a more descriptive error
        NSLog(@"Error authenticating: %@", error.description);
        
        if(_shouldHandleDialogs) {
            // tell the user
            [KTAlert showAlert:KTAlertTypeBar
                   withMessage:@"Unable to log in - verify your credentials"
                   andDuration:KTAlertDurationLong];
            
            // the authentication is complete, hide the loading view
            [KTLoader hideLoader:TRUE];
        }

    }

    // call the delegate method if the receiver is prepared for it
    @try {
        [_delegate didFinishAuthenticating:user withError:error];
    } @catch (NSException *exception) { }
    
}

#pragma mark - Action methods

- (void) performAuthentication:(id)sender
{
    
    // call the delegate method if the receiver is prepared for it
    @try {
        [_delegate didStartAuthenticating];
    } @catch (NSException *exception) { }

    // hide the keyboard and re-frame the view
    [self tappedView];

    // Get the user identifier/password from the UI
    NSString *userIdentifier = [_usernameField text];
    NSString *password = [_passwordField text];

    if(_shouldHandleDialogs) {
        // show a loading screen to the user
        [KTLoader showLoader:@"Logging in..." animated:TRUE];
    }
    
    // perform the asynchronous authentication
    [KiiUser authenticate:userIdentifier
             withPassword:password
                 andBlock:^(KiiUser *user, NSError *error) {
                     [self authComplete:user withError:error];
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
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // if the textfield is not nil, that means we're not force-hiding
    if(textField != nil) {
        
        // get the coordinates of the view and the maximum Y origin component we will allow
        CGFloat offset = textField.frame.origin.y + textField.frame.size.height + KT_KEYBOARD_PADDING_HEIGHT;
        CGFloat maximum = self.view.frame.size.height - KT_KEYBOARD_HEIGHT;
        
        // the view would be hidden or not in acceptable range, we need to slide the view
        if(offset > maximum) {
            transform = CGAffineTransformMakeTranslation(0, maximum - offset);
        }
        
    }
    
    // if the view hasn't been changed so far - it needs to be moved back to its default position
    if(CGAffineTransformIsIdentity(transform) && !CGAffineTransformIsIdentity(self.view.transform)) {
        transform = CGAffineTransformIdentity;
    }
    
    // perform the animation
    [UIView animateWithDuration:KT_KEYBOARD_ANIMATION_TIME
                     animations:^{
                         self.view.transform = transform;
                     }];
    
}

#pragma mark - Social Integration Methods
- (void) socialAuthenticationFinished:(KiiUser*)user
                         usingNetwork:(KiiSocialNetworkName)network
                            withError:(NSError*)error {
    [self authComplete:user withError:error];
}

- (void) authenticateWithFacebook
{
    
    // call the delegate method if the receiver is prepared for it
    @try {
        [_delegate didStartAuthenticating];
    } @catch (NSException *exception) { }

    if(_shouldHandleDialogs) {
        [KTLoader showLoader:@"Logging in..."];
    }

    [KiiSocialConnect logIn:kiiSCNFacebook
               usingOptions:nil
               withDelegate:self
                andCallback:@selector(socialAuthenticationFinished:usingNetwork:withError:)];
}

- (void) authenticateWithTwitter
{
    
    // call the delegate method if the receiver is prepared for it
    @try {
        [_delegate didStartAuthenticating];
    } @catch (NSException *exception) { }

    if (NSClassFromString(@"ACAccountStore")) {
        
        if(_shouldHandleDialogs) {
            [KTLoader showLoader:@"Logging in..."];
        }
        
        ACAccountStore *store = [[ACAccountStore alloc] init];
        ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // This will show a dialog asking the user to grant
        // the access to his/her Twitter accounts.
        [store requestAccessToAccountsWithType:twitterType
                                       options:nil
                                    completion:^(BOOL granted, NSError *error) {
                                        
                                        if (granted) {
                                            
                                            ACAccountType *twitterTypeGranted = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                                            
                                            // Return an array of granted ACAccounts.
                                            NSArray *twitterAccounts = [store accountsWithAccountType:twitterTypeGranted];
                                            
                                            // In this snippet, we use the first account
                                            // obtained with ACAccountStore.
                                            ACAccount* account = twitterAccounts[0];
                                            
                                            // Fetch the OAuth token and secret.
                                            NSDictionary *options = @{@"twitter_account": account};
                                            
                                            // Execute the login.
                                            [KiiSocialConnect logIn:kiiSCNTwitter
                                                       usingOptions:options
                                                       withDelegate:self
                                                        andCallback:@selector(socialAuthenticationFinished:usingNetwork:withError:)];
                                            
                                            
                                        } else {
                                            [self authComplete:nil withError:error];
                                        }
                                    }];
    } else {
        [self authComplete:nil withError:[NSError errorWithDomain:@"com.kii.error" code:1 userInfo:@{@"reason": @"ACAccountStore doesn't exist"}]];
    }
}

- (void) useFacebookAuthenticationOption
{
    // ensure our app is set up properly
    BOOL handlesURL = [[UIApplication sharedApplication].delegate respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)];
    
    
    // BEWARE!!!
    // if this assertion is failing... be sure you have added the callback
    // application:openURL:sourceApplication:annotation: to your app delegate!!
    // See instructions here:
    // http://documentation.kii.com/en/guides/ios/managing-users/social-network-integration/facebook-integration/
    assert(handlesURL);
    
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSArray *values = [mainBundle objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    
    assert(values.count > 0);
    
    NSString *facebookAppID = nil;
    
    for(NSDictionary *d in values) {
        
        NSArray *urls = [d objectForKey:@"CFBundleURLSchemes"];
        
        if(urls != nil) {
            for(NSString *url in urls) {
                if([[url substringToIndex:2] isEqualToString:@"fb"]) {
                    facebookAppID = [url substringFromIndex:2];
                }
            }
        }
        
    }
    
    // BEWARE!!!
    // if this assertion is failing... be sure you have added your facebook
    // app id to your plist file!! See instructions here:
    // http://documentation.kii.com/en/guides/ios/managing-users/social-network-integration/facebook-integration/
    assert(facebookAppID != nil);
        
    // initialize the connector
    [KiiSocialConnect setupNetwork:kiiSCNFacebook
                           withKey:facebookAppID
                         andSecret:nil
                        andOptions:nil];
    
    // add the facebook button
    
    // figure out its frame
    CGFloat x = _loginButton.frame.origin.x;
    CGFloat y = _loginButton.frame.origin.y+_loginButton.frame.size.height + 10;
    CGFloat width = (_twitterButton != nil) ? _loginButton.frame.size.width/2 - 10 : _loginButton.frame.size.width;
    CGFloat height = _loginButton.frame.size.height - 10;
    
    _facebookButton = [[KTButton alloc] initWithFrame:CGRectMake(x, y, width, height)
                                    andGradientColors:[UIColor colorWithHex:@"6e8ccc"], [UIColor colorWithHex:@"3b5998"], nil];
    _facebookButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [_facebookButton setTitle:@"Use Facebook" forState:UIControlStateNormal];
    [_facebookButton addTarget:self action:@selector(authenticateWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_facebookButton];
    
    // resize twitter button [if needed]
    if(_twitterButton != nil) {
        CGRect twFrame = _twitterButton.frame;
        twFrame.size.width = _loginButton.frame.size.width/2 - 10;
        twFrame.origin.x = self.view.frame.size.width/2 + 10;
        _twitterButton.frame = twFrame;
    }
    
    // shift the other buttons down
    CGRect frame = _noAccountLabel.frame;
    frame.origin.y = _facebookButton.frame.origin.y + _facebookButton.frame.size.height + 30;
    _noAccountLabel.frame = frame;
    
    // shift the other buttons down
    frame = _registerButton.frame;
    frame.origin.y = _noAccountLabel.frame.origin.y + _noAccountLabel.frame.size.height + 5;
    _registerButton.frame = frame;
    
    // add it to the registration view
    [_registrationView useFacebookRegistrationOption];
    
}

- (void) useTwitterAuthenticationOption:(NSString*)twitterKey
                              andSecret:(NSString*)twitterSecret
{
    // initialize the connector
    [KiiSocialConnect setupNetwork:kiiSCNTwitter
                           withKey:twitterKey
                         andSecret:twitterSecret
                        andOptions:nil];
    
    // add the twitter button
    
    // figure out its frame
    CGFloat x = (_facebookButton != nil) ? self.view.frame.size.width/2 + 10 : _loginButton.frame.origin.x;
    CGFloat y = _loginButton.frame.origin.y+_loginButton.frame.size.height + 10;
    CGFloat width = (_facebookButton != nil) ? _loginButton.frame.size.width/2 - 10 : _loginButton.frame.size.width;
    CGFloat height = _loginButton.frame.size.height - 10;
    
    _twitterButton = [[KTButton alloc] initWithFrame:CGRectMake(x, y, width, height)
                                   andGradientColors:[UIColor colorWithHex:@"00aced"], [UIColor colorWithHex:@"0084b4"], nil];
    _twitterButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [_twitterButton setTitle:@"Use Twitter" forState:UIControlStateNormal];
    [_twitterButton addTarget:self action:@selector(authenticateWithTwitter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_twitterButton];
    
    // resize facebook button [if needed]
    if(_facebookButton != nil) {
        CGRect fbFrame = _facebookButton.frame;
        fbFrame.size.width = _loginButton.frame.size.width/2 - 10;
        _facebookButton.frame = fbFrame;
    }
    
    // shift the other buttons down
    CGRect frame = _noAccountLabel.frame;
    frame.origin.y = _twitterButton.frame.origin.y + _twitterButton.frame.size.height + 30;
    _noAccountLabel.frame = frame;
    
    frame = _registerButton.frame;
    frame.origin.y = _noAccountLabel.frame.origin.y + _noAccountLabel.frame.size.height + 5;
    _registerButton.frame = frame;
    
    // add it to the registration view
    [_registrationView useTwitterRegistrationOption:twitterKey
                                          andSecret:twitterSecret];
    
}

#pragma mark - Initialization methods

- (id) init
{
    
    self = [super init];
    
    if(self) {
        
        _shouldHandleDialogs = TRUE;
        
        CGFloat baseY = [KTDevice isIOS7orLater] ? ktStatusBarHeight : 0;
        
        // initialize the registration + forgot password views for access
        _registrationView = [[KTRegistrationViewController alloc] init];
        _registrationView.loginViewController = self;
        
        _forgotPasswordView = [[KTForgotPasswordViewController alloc] init];
        _forgotPasswordView.loginViewController = self;
        
        // and set our default background color (matched to background image)
        self.view.backgroundColor = [UIColor colorWithWhite:0.76470588235f alpha:1.0f];
        
        // this image is a light gradient that blends in with the background
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, ktIphoneHeight)];
        _backgroundImage.image = [UIImage imageNamed:@"kt_login_bg"];
        _backgroundImage.contentMode = UIViewContentModeTopLeft;
        [self.view addSubview:_backgroundImage];
        
        // create and add the close button
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0, baseY, 40, 40);
        _closeButton.backgroundColor = [UIColor clearColor];
        [_closeButton setImage:[UIImage imageNamed:@"kt_login_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeButton];
        
        
        // create and add the title image (defaults to Kii logo)
        _titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kt_login_kii_logo"]];
        _titleImage.contentMode = UIViewContentModeCenter;
        _titleImage.clipsToBounds = FALSE;
        _titleImage.frame = CGRectMake(20, baseY, 280, 70);
        [self.view addSubview:_titleImage];
        
        
        // set the default size/offset for our text fields
        CGFloat xOffset = 28;
        CGFloat width = 320 - xOffset*2;
        
        // create the colors to use for our text field borders and button gradients
        UIColor *darkOrange = [UIColor colorWithHex:@"D27422"];
        UIColor *lightOrange = [UIColor colorWithHex:@"F89743"];
        UIColor *darkGreen = [UIColor colorWithHex:@"005404"];
        UIColor *lightGreen = [UIColor colorWithHex:@"009C00"];
        
        baseY += 70;
        
        // create and add the username field
        _usernameField = [KTTextField textFieldWithFrame:CGRectMake(xOffset, baseY, width, 40)
                                          andBorderColor:lightOrange
                                                andGlows:TRUE];
        _usernameField.delegate = self;
        _usernameField.placeholder = @"Username, email or phone number";
        _usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _usernameField.returnKeyType = UIReturnKeyNext;
        [self.view addSubview:_usernameField];
        
        baseY += 54;
        
        // create and add the password field
        _passwordField = [KTTextField textFieldWithFrame:CGRectMake(xOffset, baseY, width, 40)
                                          andBorderColor:lightOrange
                                                andGlows:TRUE];
        _passwordField.delegate = self;
        _passwordField.placeholder = @"Enter your password";
        _passwordField.secureTextEntry = TRUE;
        _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordField.returnKeyType = UIReturnKeyDone;
        [self.view addSubview:_passwordField];
        
        baseY += 54;
        
        // create and add the login button
        _loginButton = [[KTButton alloc] initWithFrame:CGRectMake(xOffset, baseY, width, 45)
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