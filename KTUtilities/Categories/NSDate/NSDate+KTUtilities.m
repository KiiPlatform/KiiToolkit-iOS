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

#import "NSDate+KTUtilities.h"

@implementation NSDate (KTUtilities)

- (NSString*) timeAgo:(BOOL)shortened
{
    NSString *retString = @"";
    double changeSeconds = [[NSDate date] timeIntervalSinceDate:self];
    int changeSecondInt = (int) changeSeconds;
    int changeMinutes = floor(changeSeconds / 60);
    int changeHours = floor(changeMinutes / 60);
    int changeDays = floor(changeHours / 24);
    int changeWeeks = floor(changeDays / 7);
    int changeMonths = floor(changeWeeks / 4);
    int changeYears = floor(changeMonths / 12);
    
    if(changeSeconds < 5) {
        retString = @"Just Now";
    } else if(changeSeconds < 60) {
        retString = [NSString stringWithFormat:@"%d%@%@ ago", changeSecondInt, (shortened?@"s":@" second"), (changeSecondInt==1||shortened)?@"":@"s"];
    } else if(changeMinutes < 60) {
        retString = [NSString stringWithFormat:@"%d%@%@ ago", changeMinutes, (shortened?@"m":@" minute"), (changeMinutes==1||shortened)?@"":@"s"];
    } else if(changeHours < 24) {
        retString = [NSString stringWithFormat:@"%d%@%@ ago", changeHours, (shortened?@"h":@" hour"), (changeHours==1||shortened)?@"":@"s"];
    } else if(changeDays < 7) {
        retString = [NSString stringWithFormat:@"%d%@%@ ago", changeDays, (shortened?@"d":@" day"), (changeDays==1||shortened)?@"":@"s"];
    } else if(changeWeeks < 4) {
        retString = [NSString stringWithFormat:@"%d%@%@ ago", changeWeeks, (shortened?@"w":@" week"), (changeWeeks==1||shortened)?@"":@"s"];
    } else if(changeMonths < 12) {
        retString = [NSString stringWithFormat:@"%d%@%@ ago", changeMonths, (shortened?@"mo":@" month"), (changeMonths==1||shortened)?@"":@"s"];
    } else {
        retString = [NSString stringWithFormat:@"%d%@%@ ago", changeYears, (shortened?@"y":@" year"), (changeYears==1||shortened)?@"":@"s"];
    }
    
    return retString;
}

@end
