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

#import "KTForgotPasswordViewController.h"

#if __has_include(<KiiSDK/Kii.h>)

#import "KiiToolkit.h"
#import "KTLoginViewController.h"
#import <KiiSDK/Kii.h>
#import <QuartzCore/QuartzCore.h>

@implementation KTForgotPasswordViewController

#pragma mark - Action methods

- (void) performReset:(id)sender
{
    
    // get the entered user identifier from the UI
    NSString *userIdentifier = _userIdentifierField.text;
    
    // hide the keyboard (if needed)
    [_userIdentifierField resignFirstResponder];
    
    if(_loginViewController.shouldHandleDialogs) {
        // show a loading screen to the user
        [KTLoader showLoader:@"Resetting password..." animated:TRUE];
    }

    // call the delegate method if the receiver is prepared for it
    @try {
        [self.loginViewController.delegate didStartResettingPassword];
    } @catch (NSException *exception) { }

    // perform the asynchronous action
    [KiiUser resetPassword:userIdentifier
                 withBlock:^(NSError *error) {
                     
                     // reset was successful
                     if(error == nil) {
                         
                         if(_loginViewController.shouldHandleDialogs) {
                             // show the user
                             [KTLoader showLoader:@"Password reset sent!"
                                         animated:TRUE
                                    withIndicator:KTLoaderIndicatorSuccess
                                  andHideInterval:KTLoaderDurationAuto];
                         }
                         
                         // and hide this view
                         [self dismissViewControllerAnimated:TRUE completion:nil];
                     }
                     
                     // reset failed
                     else {
                         
                         // tell the console with a descriptive message
                         NSLog(@"Error resetting password: %@", error.description);

                         if(_loginViewController.shouldHandleDialogs) {
                             // tell the user
                             [KTAlert showAlert:KTAlertTypeBar
                                    withMessage:@"Error: unable to reset password"
                                    andDuration:KTAlertDurationLong];
                             
                             // the action is complete, hide the loading view
                             [KTLoader hideLoader:TRUE];
                         }

                     }
                     
                     // call the delegate method if the receiver is prepared for it
                     @try {
                         [self.loginViewController.delegate didFinishResettingPassword:error];
                     } @catch (NSException *exception) { }
                     
                 }];

}

// the user clicked the 'close' button
- (void) closeView:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

// called when the user has tapped the background view.
// made so the keyboard will disappear when the user wants to hide it and go back to the view
- (void) tappedView
{
    [_userIdentifierField resignFirstResponder];
}

#pragma mark - Initialization methods

- (id) init
{
    
    self = [super init];
    
    if(self) {
        
        CGFloat baseY = [KTDevice isIOS7orLater] ? ktStatusBarHeight : 0;

        // define the offset & width of the text field
        CGFloat xOffset = 28;
        CGFloat width = 320 - xOffset*2;
        
        // and the colors to be used in our action button
        UIColor *darkOrange = [UIColor colorWithHex:@"D27422"];
        UIColor *lightOrange = [UIColor colorWithHex:@"F89743"];

        // and set our default background color (matched to background image)
        self.view.backgroundColor = [UIColor colorWithWhite:0.76470588235f alpha:1.0f];
        
        // this image is a light gradient that blends in with the background
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, ktIphone5Height)];
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

        baseY += 100;
        
        // create and add the user identifier field
        _userIdentifierField = [KTTextField textFieldWithFrame:CGRectMake(xOffset, baseY, width, 40)
                                                andBorderColor:lightOrange
                                                      andGlows:TRUE];
        _userIdentifierField.delegate = self;
        _userIdentifierField.placeholder = @"Email address or phone number";
        _userIdentifierField.keyboardType = UIKeyboardTypeDefault;
        _userIdentifierField.returnKeyType = UIReturnKeyDone;
        _userIdentifierField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.view addSubview:_userIdentifierField];
        
        
        
        // create and add the action button
        CGRect frame = CGRectMake(xOffset, _userIdentifierField.frame.origin.y + _userIdentifierField.frame.size.height + 20, width, 45);
        _sendResetButton = [[KTButton alloc] initWithFrame:frame
                                         andGradientColors:lightOrange, darkOrange, nil];
        
        [_sendResetButton setTitle:@"Reset Password" forState:UIControlStateNormal];
        [self.view addSubview:_sendResetButton];
        [_sendResetButton addTarget:self action:@selector(performReset:) forControlEvents:UIControlEventTouchUpInside];

        

        // we want to hide the keyboard when the user taps the background, so create and add the recognizer here
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView)];
        [self.view addGestureRecognizer:tap];

    }
    
    return self;
}

#pragma mark - UITextField delegate methods

// the user has hit the 'done' button
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    // hide the keyboard
    [textField resignFirstResponder];
    return FALSE;
}


@end

#endif