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

#import "KTLoader.h"

#import "UIView+KTUtilities.h"
#import "KTCircularProgressIndicator.h"
#import <QuartzCore/QuartzCore.h>

// Constants
#define KTLoaderFadeDuration    0.3

@interface KTLoader()

@property (nonatomic, strong) KTCircularProgressIndicator *progressIndicator;
@property (nonatomic, strong) UIView *loader;
@property (nonatomic, strong) UILabel *loaderLabel;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIImageView *indicator;

@end

@implementation KTLoader

static KTLoader *sharedInstance = nil;

#pragma mark - Display methods

- (void) initLoader
{
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    
    _loader = [[UIView alloc] initWithFrame:appWindow.bounds];
    _loader.backgroundColor = [UIColor clearColor];
    _loader.hidden = TRUE;
    _loader.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIView *loaderBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    loaderBG.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    loaderBG.layer.cornerRadius = 10.0f;
    loaderBG.layer.shadowColor = [UIColor blackColor].CGColor;
    loaderBG.center = CGPointMake(_loader.frame.size.width/2, _loader.frame.size.height/2);
    loaderBG.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [loaderBG normalizeView];
    [_loader addSubview:loaderBG];
    
    _loaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, loaderBG.bounds.size.height-50, loaderBG.bounds.size.width-8, 50)];
    _loaderLabel.backgroundColor = [UIColor clearColor];
    _loaderLabel.text = @"Loading...";
    _loaderLabel.textAlignment = NSTextAlignmentCenter;
    _loaderLabel.textColor = [UIColor whiteColor];
    _loaderLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _loaderLabel.numberOfLines = 2;
    [loaderBG addSubview:_loaderLabel];
    [_loaderLabel normalizeView];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(loaderBG.bounds.size.width/2, (loaderBG.bounds.size.height)/3);
    [loaderBG addSubview:_spinner];
    [_spinner normalizeView];
    
    _indicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _indicator.center = _spinner.center;
    _indicator.contentMode = UIViewContentModeCenter;
    [loaderBG addSubview:_indicator];
    [_indicator normalizeView];
    
    _progressIndicator = [[KTCircularProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _progressIndicator.center = _spinner.center;
    [loaderBG addSubview:_progressIndicator];
    [_progressIndicator normalizeView];
    
    // add this view to our window so it overlays everything
    [appWindow addSubview:_loader];

}

+ (void) showLoader:(NSString*)message
           animated:(BOOL)animated
      withIndicator:(KTLoaderIndicatorType)indicator
    andHideInterval:(KTLoaderIndicatorDuration)hideInterval
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(indicator == KTLoaderIndicatorSpinner) {
            [[KTLoader sharedInstance].spinner startAnimating];
            [KTLoader sharedInstance].indicator.hidden = TRUE;
            [KTLoader sharedInstance].progressIndicator.hidden = TRUE;
        } else if(indicator == KTLoaderIndicatorProgress){
            
            [[KTLoader sharedInstance].spinner stopAnimating];
            [KTLoader sharedInstance].indicator.hidden = TRUE;
            
            [[KTLoader sharedInstance].progressIndicator setProgress:0.0f];
            [KTLoader sharedInstance].progressIndicator.hidden = FALSE;
            
        } else {
            
            NSString *src = (indicator == KTLoaderIndicatorSuccess) ? @"success-indicator" : @"failure-indicator";
            [KTLoader sharedInstance].indicator.image = [UIImage imageNamed:src];
            
            [[KTLoader sharedInstance].spinner stopAnimating];
            [KTLoader sharedInstance].indicator.hidden = FALSE;
            [KTLoader sharedInstance].progressIndicator.hidden = TRUE;
        }
        
        [KTLoader sharedInstance].loaderLabel.text = message;
        [KTLoader sharedInstance].loader.hidden = FALSE;
        [KTLoader sharedInstance].loader.alpha = 1.0f;
        
        if(hideInterval > KTLoaderDurationIndefinite) {
            [KTLoader performSelector:@selector(hideLoader) withObject:nil afterDelay:(hideInterval/1000)];
        }
        
    });
}

+ (void) showLoader:(NSString*)message
           animated:(BOOL)animated
      withIndicator:(KTLoaderIndicatorType)indicator
{
    [KTLoader showLoader:message
                animated:animated
           withIndicator:indicator
         andHideInterval:KTLoaderDurationIndefinite];
}

+ (void) showLoader:(NSString*)message
           animated:(BOOL)animated
{
    [KTLoader showLoader:message
                animated:animated
           withIndicator:KTLoaderIndicatorSpinner];
}

+ (void) showLoader:(NSString*)message
{
    [KTLoader showLoader:message
                animated:TRUE];
}

+ (void) hideLoader:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // if the process should be animated
        if(animated) {
            
            // fade it out nicely
            [UIView animateWithDuration:KTLoaderFadeDuration
                             animations:^{
                                 [KTLoader sharedInstance].loader.alpha = 0.0f;
                             } completion:^(BOOL finished) {
                                 [[KTLoader sharedInstance].loader setHidden:TRUE];
                             }];
        }
        
        // otherwise, just remove it from the superview
        else {
            [[KTLoader sharedInstance].loader setHidden:TRUE];
        }
        
    });
}

+ (void) hideLoader
{
    [KTLoader hideLoader:TRUE];
}

+ (void) setProgress:(double)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[KTLoader sharedInstance].progressIndicator setProgress:progress];
    });
}

+ (KTCircularProgressIndicator*)progressIndicator
{
    return [KTLoader sharedInstance].progressIndicator;
}


/*
 It is important to leave this empty. This class should persist throughout the
 lifetime of the app, so any call to dealloc should be ignored
 */
- (void) dealloc { }

+ (KTLoader*) sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
        [sharedInstance initLoader];
    }
    
    return sharedInstance;
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedInstance];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}


@end
