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

#import "KTAppRater.h"

#import "KTNetworkingUtilities.h"

#define KTAPPRATER_STORED_OPEN_COUNT                    @"com.kii.ktapprater.opencount"
#define KTAPPRATER_STORED_FIRST_OPEN                    @"com.kii.ktapprater.firstopen"
#define KTAPPRATER_STORED_HAS_DECLINED                  @"com.kii.ktapprater.hasdeclined"
#define KTAPPRATER_STORED_HAS_RATED                     @"com.kii.ktapprater.hasrated"
#define KTAPPRATER_STORED_LAST_DELAYED                  @"com.kii.ktapprater.lastdelayed"

#define KTAPPRATER_DEFAULT_MINIMUM_DAYS_BEFORE_DISPLAY  5
#define KTAPPRATER_DEFAULT_MINIMUM_USES_BEFORE_DISPLAY  10
#define KTAPPRATER_DEFAULT_DAYS_BEFORE_REMINDING        2

@interface KTAppRater()

@property (nonatomic, strong) NSString *appID;

@property (nonatomic, assign) int minimumDaysBeforeDisplay;
@property (nonatomic, assign) int minimumUsesBeforeDisplay;
@property (nonatomic, assign) int daysBeforeReminding;

@property (nonatomic, strong) NSString *alertMessage;
@property (nonatomic, strong) NSString *alertTitle;

@property (nonatomic, strong) NSString *alertDeclineButtonTitle;
@property (nonatomic, strong) NSString *alertRateNowButtonTitle;
@property (nonatomic, strong) NSString *alertReminderButtonTitle;

+ (void) incrementOpenCount;
+ (BOOL) requirementsMet;
+ (void) setFirstOpen;

@end

@implementation KTAppRater

static KTAppRater *sharedInstance = nil;

+ (void) setAlertMessage:(NSString*)alertMessage
{
    [[KTAppRater sharedInstance] setAlertMessage:alertMessage];
}

+ (void) setAlertTitle:(NSString*)alertTitle
{
    [[KTAppRater sharedInstance] setAlertTitle:alertTitle];
}

+ (void) setAlertDeclineButtonTitle:(NSString*)alertDeclineButtonTitle
{
    [[KTAppRater sharedInstance] setAlertDeclineButtonTitle:alertDeclineButtonTitle];
}

+ (void) setAlertRateNowButtonTitle:(NSString*)alertRateNowButtonTitle
{
    [[KTAppRater sharedInstance] setAlertRateNowButtonTitle:alertRateNowButtonTitle];
}

+ (void) setAlertReminderButtonTitle:(NSString*)alertReminderButtonTitle
{
    [[KTAppRater sharedInstance] setAlertReminderButtonTitle:alertReminderButtonTitle];
}

+ (void) setMinimumDaysBeforeDisplay:(int)minimumDays
{
    [[KTAppRater sharedInstance] setMinimumDaysBeforeDisplay:minimumDays];
}

+ (void) setMinimumUsesBeforeDisplay:(int)minimumUses
{
    [[KTAppRater sharedInstance] setMinimumUsesBeforeDisplay:minimumUses];
}

+ (void) setDaysBeforeReminding:(int)daysBeforeReminding
{
    [[KTAppRater sharedInstance] setDaysBeforeReminding:daysBeforeReminding];
}

+ (void) setLastDelayed
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:KTAPPRATER_STORED_LAST_DELAYED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) setFirstOpen
{
    // see if we have a 'first open' date saved
    NSDate *firstOpen = [[NSUserDefaults standardUserDefaults] objectForKey:KTAPPRATER_STORED_FIRST_OPEN];
    
    // if not, set it
    if(firstOpen == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:KTAPPRATER_STORED_FIRST_OPEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

+ (BOOL) shouldDelay
{
    BOOL ret = FALSE;
    
    // get the last delay time
    NSDate *lastDelayed = [[NSUserDefaults standardUserDefaults] objectForKey:KTAPPRATER_STORED_LAST_DELAYED];

    // if we've been delayed
    if(lastDelayed != nil) {

        double secondsPerDay = 24 * 60 * 60;
        
        // see what the next possible ask time is
        NSDate *minimumNextAsk = [lastDelayed dateByAddingTimeInterval:[KTAppRater sharedInstance].daysBeforeReminding*secondsPerDay];
        
        NSDate *now = [NSDate date];
        
        // see if we're not yet to the minimum date
        if ([now compare:minimumNextAsk] == NSOrderedAscending) {
                        
            // this is the only way we should delay - if the
            // user has asked for a delay and not enough time has passed
            ret = TRUE;
        }
    }
    
    // if so, return true
    return ret;
}

+ (void) incrementOpenCount
{
    // get the current count
    int current = [[NSUserDefaults standardUserDefaults] integerForKey:KTAPPRATER_STORED_OPEN_COUNT];
    
    // increment the current count
    ++current;
    
    // store the new value
    [[NSUserDefaults standardUserDefaults] setInteger:current forKey:KTAPPRATER_STORED_OPEN_COUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) requirementsMet
{
    // check to see if the days have passed
    NSDate *firstOpen = [[NSUserDefaults standardUserDefaults] objectForKey:KTAPPRATER_STORED_FIRST_OPEN];
    double secondsPassed = [[NSDate date] timeIntervalSinceDate:firstOpen];
    double secondsPerDay = 60 * 60 * 24;
    int daysPassed = floor(secondsPassed / secondsPerDay);
    BOOL daysMet = (daysPassed >= [KTAppRater sharedInstance].minimumDaysBeforeDisplay);
    
    // check to see if the launch count has passed
    int openCount = [[NSUserDefaults standardUserDefaults] integerForKey:KTAPPRATER_STORED_OPEN_COUNT];
    BOOL openMet = (openCount >= [KTAppRater sharedInstance].minimumUsesBeforeDisplay);
    
    // check to see if the user has 'delayed'
    BOOL shouldDelay = [KTAppRater shouldDelay];
    
    // check to see if the user has declined
    BOOL declined = [[NSUserDefaults standardUserDefaults] boolForKey:KTAPPRATER_STORED_HAS_DECLINED];
    
    // check to see if they've already rated it
    BOOL hasRated = [[NSUserDefaults standardUserDefaults] boolForKey:KTAPPRATER_STORED_HAS_RATED];
    
    return (daysMet && openMet && !declined && !hasRated && !shouldDelay);
}

+ (void) appOpened
{
    // set the first open time (if not already set)
    [KTAppRater setFirstOpen];
    
    // update the open count
    [KTAppRater incrementOpenCount];
    
    // check to see if the minimum requirements have been met
    BOOL shouldDisplay = [KTAppRater requirementsMet];
    
    // if so, make sure we have a connection
    BOOL hasConnection = [KTNetworkingUtilities hasConnection];
        
    // if everything is good, show it!
    if(shouldDisplay && hasConnection) {

        UIAlertView *av = [[UIAlertView alloc] initWithTitle:[KTAppRater sharedInstance].alertTitle
                                                     message:[KTAppRater sharedInstance].alertMessage
                                                    delegate:self
                                           cancelButtonTitle:[KTAppRater sharedInstance].alertDeclineButtonTitle
                                           otherButtonTitles:[KTAppRater sharedInstance].alertRateNowButtonTitle, [KTAppRater sharedInstance].alertReminderButtonTitle, nil];
        [av show];
    }

}

+(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // take the user to the app store
    if(buttonIndex == 1) {
        NSString *urlString = [NSString stringWithFormat:@"itms://itunes.apple.com/app/id%@", [KTAppRater sharedInstance].appID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
        // mark this as being 'rated' so we don't show it again
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:KTAPPRATER_STORED_HAS_RATED];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    // set the last delayed time to now and dismiss
    else if(buttonIndex == 2) {
        [KTAppRater setLastDelayed];
    }
    
    // the user has chosen to not show again
    else {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:KTAPPRATER_STORED_HAS_DECLINED];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void) configureAppID:(NSString*)appId
{
    // ensure this is set
    NSString *assertionMessage = @"KTAppRater not configured properly. Be sure to set KTAPPRATER_APPID to your app's ID in KTAppRater.h";
    NSAssert(appId != nil, assertionMessage);
    NSAssert(![appId isEqualToString:@""], assertionMessage);

    // save it for later
    _appID = appId;
    
    // and set up the defaults
    _minimumDaysBeforeDisplay = KTAPPRATER_DEFAULT_MINIMUM_DAYS_BEFORE_DISPLAY;
    _minimumUsesBeforeDisplay = KTAPPRATER_DEFAULT_MINIMUM_USES_BEFORE_DISPLAY;
    _daysBeforeReminding = KTAPPRATER_DEFAULT_DAYS_BEFORE_REMINDING;
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [info objectForKey:@"CFBundleDisplayName"];

    // set the default strings here
    _alertMessage = [NSString stringWithFormat:@"Thanks for using %@! If you enjoy it, would you mind giving it a 5-star rating on the app store? We'd really appreciate it!", appName];
    _alertTitle = [NSString stringWithFormat:@"Rate %@!", appName];
    
    _alertDeclineButtonTitle = @"No, thanks";
    _alertRateNowButtonTitle = @"Rate it now!";
    _alertReminderButtonTitle = @"Remind me later";
}

#pragma mark public static methods
+ (void) configureAppID:(NSString*)appId
{
    [[KTAppRater sharedInstance] configureAppID:appId];
}


#pragma mark - singleton management
+ (KTAppRater*) sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
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

/*
 It is important to leave this empty. This class should persist throughout the
 lifetime of the app, so any call to dealloc should be ignored
 */
- (void) dealloc { }


@end
