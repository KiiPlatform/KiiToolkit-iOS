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

#import "KTNetworkingUtilities.h"

#import <SystemConfiguration/SystemConfiguration.h>

#import <netinet/in.h>
#import <netinet6/in6.h>

@implementation KTNetworkingUtilities

+ (BOOL) hasConnection
{
    BOOL isReachable = FALSE;
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    // make sure we're initialized
    if(reachability != NULL) {
        
        // make sure we can get the flags
        if(SCNetworkReachabilityGetFlags(reachability, &flags)) {
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                isReachable = TRUE;
            }
            
            
            else if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                      (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
                    // ... and no [user] intervention is needed
                    isReachable = TRUE;
                }
            }
            
            else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                isReachable = TRUE;
            }
        }
        
        
    }
    
    return isReachable;
}

@end
