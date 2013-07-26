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

#import "NSString+KTUtilities.h"

#define UPPERCASE   @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#define LOWERCASE   [UPPERCASE lowercaseString]
#define NUMERIC     @"1234567890"

@implementation NSString (KTUtilities)

+ (NSString*) charactersForSet:(KTCharacterSet)set
{
    NSString *string = @"";
    
    if (set & KTCharacterSetLowercase) {
        string = [string stringByAppendingString:LOWERCASE];
    }
    
    if(set & KTCharacterSetUppercase) {
        string = [string stringByAppendingString:UPPERCASE];
    }
    
    if(set & KTCharacterSetNumeric) {
        string = [string stringByAppendingString:NUMERIC];
    }
    
    return string;
}

+ (NSString*) randomString:(int)len withCharacterSet:(KTCharacterSet)charSet
{
    
    NSString *selection = [NSString charactersForSet:charSet];
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat:@"%c", [selection characterAtIndex:arc4random()%selection.length]];
    }
    
    return randomString;
}

+ (NSString*) randomString:(int)len
{
    return [NSString randomString:len withCharacterSet:KTCharacterSetAlphanumeric];
}

- (BOOL) containsString:(NSString*)needle
{
    return [self rangeOfString:needle].location != NSNotFound;
}

- (BOOL) containsCharacter:(char)needle
{
    return [self containsString:[NSString stringWithFormat:@"%c", needle]];
}

@end
