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

#import "KTRegistrationViewController.h"
#import "KTForgotPasswordViewController.h"
#import <KiiSDK/Kii.h>
#import <QuartzCore/QuartzCore.h>

@interface KTRegistrationViewController () {
    UIScrollView *_scrollContainer;
    CGFloat _originalY;
}

- (void) drawView;
- (void) shiftView:(UITextField*)field;

@end

@implementation KTRegistrationViewController


#pragma mark - Overridden setter methods

// override the setter so we can re-draw the view with the new fields
- (void) setDisplayFields:(NSUInteger)displayFields
{
    // set our variable
    _displayFields = displayFields;
    
    // redraw the view
    [self drawView];
}

#pragma mark - Action methods

- (void) performRegistration:(id)sender
{
    
    // hide the keyboard and shift the view (if needed)
    [self tappedView];

    // create somewhere to store our user and any attributes we might need
    KiiUser *user = nil;
    NSString *loginName, *emailAddress, *phoneNumber = nil;
    
    // load the password from the UI
    NSString *password = [_passwordField text];
    
    // figure out which credentials we have
    if((_displayFields & KTRegistrationFieldLoginName) > 0) {
        loginName = [_loginNameField text];
    }
    
    if((_displayFields & KTRegistrationFieldEmailAddress) > 0) {
        emailAddress = [_emailAddressField text];
    }
    
    if((_displayFields & KTRegistrationFieldPhoneNumber) > 0) {
        phoneNumber = [_phoneNumberField text];
    }
    
    // build the object
    if(loginName != nil && emailAddress != nil && phoneNumber != nil) {
        user = [KiiUser userWithUsername:loginName
                         andEmailAddress:emailAddress
                          andPhoneNumber:phoneNumber
                             andPassword:password];
    } else if(loginName != nil && emailAddress != nil) {
        user = [KiiUser userWithUsername:loginName
                         andEmailAddress:emailAddress
                             andPassword:password];
    } else if(loginName != nil && phoneNumber != nil) {
        user = [KiiUser userWithUsername:loginName
                          andPhoneNumber:phoneNumber
                             andPassword:password];
    } else if(emailAddress != nil && phoneNumber != nil) {
        user = [KiiUser userWithEmailAddress:emailAddress
                              andPhoneNumber:phoneNumber
                                 andPassword:password];
    } else if(loginName != nil) {
        user = [KiiUser userWithUsername:loginName andPassword:password];
    } else if(emailAddress != nil) {
        user = [KiiUser userWithEmailAddress:emailAddress andPassword:password];
    } else if(phoneNumber != nil) {
        user = [KiiUser userWithPhoneNumber:phoneNumber andPassword:password];
    }

    // assume we have a user created
    if(user != nil) {

        // show a loading screen to the user
        [KTLoader showLoader:@"Registering user..." animated:TRUE];
        
        // perform the registration asynchronously
        [user performRegistrationWithBlock:^(KiiUser *user, NSError *error) {
            
            // registration was successful
            if(error == nil) {
                
                // show success
                [KTLoader showLoader:@"Registered!"
                            animated:TRUE
                       withIndicator:KTLoaderIndicatorSuccess
                     andHideInterval:KTLoaderDurationAuto];
                
                // hide this view
                [self dismissViewControllerAnimated:TRUE completion:nil];
            }
            
            // registration failed
            else {
                
                // build a short message for the user
                NSString *subMessage = @"ensure all fields are filled out";
                switch (error.code) {
                    case 304: subMessage = @"invalid password format"; break;
                    case 305: subMessage = @"invalid email format"; break;
                    case 307: subMessage = @"invalid username format"; break;
                    case 308: subMessage = @"invalid phone number format"; break;
                    case 310: subMessage = @"invalid display name format"; break;
                    case 503: subMessage = @"user already exists"; break;
                    default: break;
                }
                
                NSString *message = [NSString stringWithFormat:@"Error: %@", subMessage];
                                
                // tell the user
                [KTAlert showAlert:KTAlertTypeBar
                       withMessage:message
                       andDuration:KTAlertDurationLong];
                
                // tell the console with a more descriptive description
                NSLog(@"Error creating object: %@", error.description);
                
                // hide the loading UI element
                [KTLoader hideLoader:TRUE];
            }

        }];
    }
    
    // otherwise, there was an error creating the object
    else {
                
        // tell the user
        [KTAlert showAlert:KTAlertTypeBar
               withMessage:@"Error: ensure all fields are filled out"
               andDuration:KTAlertDurationLong];
        
        // tell the console
        NSLog(@"Error creating object: user was nil");

    }
    
}

// the user clicked the 'close' button
- (void) closeView:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

#pragma mark - View management methods

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

- (NSMutableArray*) liveTextFields:(UIView*)view
{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for(UIView *v in view.subviews) {
        if([v isKindOfClass:[UITextField class]]) {
            [array addObject:v];
        } else {
            [array addObjectsFromArray:[self liveTextFields:v]];
        }
    }
    
    return array;

}

// called when the user has tapped the background view.
// made so the keyboard will disappear when the user wants to hide it and go back to the view
- (void) tappedView
{
    
    // resign the text for any textfields in the view
    for(UITextField *field in [self liveTextFields:self.view]) {
        [field resignFirstResponder];
    }
    
    // slide the view back to normal
    [self shiftView:nil];
    
}

// draw the view based on the text inputs the definition requires
- (void) drawView {
    
    // first remove all elements from the view
    for(UIView *v in _scrollContainer.subviews) {
        [v removeFromSuperview];
    }    
    
    
    // define the offset & width of the text field
    CGFloat xOffset = 28;
    CGFloat width = 320 - xOffset*2;
    CGFloat yOffset = 100;

    // and the colors to be used in our action button
    UIColor *darkOrange = [UIColor colorWithHex:@"D27422"];
    UIColor *lightOrange = [UIColor colorWithHex:@"F89743"];
    
    
    // create and add the close button
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(0, 0, 48, 48);
    _closeButton.backgroundColor = [UIColor clearColor];
    [_closeButton setImage:[UIImage imageNamed:@"kt_login_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollContainer addSubview:_closeButton];
    
    
    
    // create and add the title image (defaults to Kii logo)
    _titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kt_login_kii_logo"]];
    _titleImage.contentMode = UIViewContentModeCenter;
    _titleImage.clipsToBounds = FALSE;
    _titleImage.frame = CGRectMake(20, 30, 280, 70);
    [_scrollContainer addSubview:_titleImage];

    
    
    // if the fields should display the login name
    if((_displayFields & KTRegistrationFieldLoginName) > 0) {
        
        // create and add the field
        _loginNameField = [KTTextField textFieldWithFrame:CGRectMake(xOffset, yOffset, width, 40)
                                           andBorderColor:lightOrange
                                                 andGlows:TRUE];
        _loginNameField.delegate = self;
        _loginNameField.placeholder = @"Username";
        _loginNameField.keyboardType = UIKeyboardTypeDefault;
        _loginNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _loginNameField.returnKeyType = UIReturnKeyNext;
        [_scrollContainer addSubview:_loginNameField];
        
        // increment the yOffset so the next view is located properly
        yOffset += 54.0f;
    }
    

    // if the fields should display the email address
    if((_displayFields & KTRegistrationFieldEmailAddress) > 0) {
        
        // create and add the field
        _emailAddressField = [KTTextField textFieldWithFrame:CGRectMake(xOffset, yOffset, width, 40)
                                              andBorderColor:lightOrange
                                                    andGlows:TRUE];
        _emailAddressField.delegate = self;
        _emailAddressField.placeholder = @"Email Address";
        _emailAddressField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailAddressField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailAddressField.returnKeyType = UIReturnKeyNext;
        [_scrollContainer addSubview:_emailAddressField];

        // increment the yOffset so the next view is located properly
        yOffset += 54.0f;
    }
    

    // if the fields should display the display name
    if((_displayFields & KTRegistrationFieldDisplayName) > 0) {
        
        // create and add the field
        _displayNameField = [KTTextField textFieldWithFrame:CGRectMake(xOffset, yOffset, width, 40)
                                             andBorderColor:lightOrange
                                                   andGlows:TRUE];
        _displayNameField.delegate = self;
        _displayNameField.placeholder = @"Display Name";
        _displayNameField.keyboardType = UIKeyboardTypeDefault;
        _displayNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _displayNameField.returnKeyType = UIReturnKeyNext;
        [_scrollContainer addSubview:_displayNameField];

        // increment the yOffset so the next view is located properly
        yOffset += 54.0f;
    }
    
    // if the fields should display the phone number
    if((_displayFields & KTRegistrationFieldPhoneNumber) > 0) {
        
        // create and add the field
        _phoneNumberField = [KTTextField textFieldWithFrame:CGRectMake(xOffset, yOffset, width, 40)
                                             andBorderColor:lightOrange
                                                   andGlows:TRUE];
        _phoneNumberField.delegate = self;
        _phoneNumberField.placeholder = @"Phone Number";
        _phoneNumberField.keyboardType = UIKeyboardTypePhonePad;
        _phoneNumberField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _phoneNumberField.returnKeyType = UIReturnKeyNext;
        [_scrollContainer addSubview:_phoneNumberField];

        // increment the yOffset so the next view is located properly
        yOffset += 54.0f;
    }
    
    // create and add the password field
    _passwordField = [KTTextField textFieldWithFrame:CGRectMake(xOffset, yOffset, width, 40)
                                      andBorderColor:lightOrange
                                            andGlows:TRUE];
    _passwordField.delegate = self;
    _passwordField.placeholder = @"Password";
    _passwordField.secureTextEntry = TRUE;
    _passwordField.keyboardType = UIKeyboardTypeDefault;
    _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordField.returnKeyType = UIReturnKeyDone;
    [_scrollContainer addSubview:_passwordField];

    // increment the yOffset so the button is located properly
    yOffset += 54.0;
    
    
    // create and add the registration button
    _registerButton = [[KTButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, width, 45)
                                    andGradientColors:lightOrange, darkOrange, nil];
    [_registerButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [_scrollContainer addSubview:_registerButton];
    [_registerButton addTarget:self action:@selector(performRegistration:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // we want to hide the keyboard when the user taps the background, so create and add the recognizer here
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView)];
    [_scrollContainer addGestureRecognizer:tap];
    
    
    // set the scroll container height
    _scrollContainer.contentSize = CGSizeMake(_scrollContainer.frame.size.width, _registerButton.frame.origin.y + _registerButton.frame.size.height + 60);
    
}

#pragma mark - Initialization methods

- (id) init
{
    
    self = [super init];
    
    if(self) {
        
        // store the original y coordinate
        _originalY = self.view.frame.origin.y;
        
        // set our default display field(s) to login name (username) only
        _displayFields = KTRegistrationFieldLoginName;
        
        // and set our default background color (matched to background image)
        self.view.backgroundColor = [UIColor colorWithWhite:0.76470588235f alpha:1.0f];
        
        // this image is a light gradient that blends in with the background
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        _backgroundImage.image = [UIImage imageNamed:@"kt_login_bg"];
        _backgroundImage.contentMode = UIViewContentModeTopLeft;
        [self.view addSubview:_backgroundImage];
        
        // create and add the scroll container
        _scrollContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:_scrollContainer];

        // and draw the default view
        // this can be redrawn later if the developer changes fields
        [self drawView];
    }
    
    return self;
}

#pragma mark - UITextField delegate methods

// one of the textfields is being edited
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self shiftView:textField];
}

// the user has hit the 'next' or 'done' button
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    // the user hit 'done', hide the keyboard
    if([textField isEqual:_passwordField]) {
        [textField resignFirstResponder];
        
        // also, slide the view down (if needed)
        [self shiftView:nil];
    }
    
    // the user hit next
    else {
        
        NSMutableArray *textFields = [self liveTextFields:self.view];
        
        // figure out which field was selected
        int ndx = [textFields indexOfObject:textField];
        
        // now select the next one
        [[textFields objectAtIndex:++ndx] becomeFirstResponder];
        
    }
    
    return FALSE;
}

@end

#endif