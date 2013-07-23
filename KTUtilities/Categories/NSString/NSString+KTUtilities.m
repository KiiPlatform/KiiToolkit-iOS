//
//  NSString+KTUtilities.m
//  KiiToolkit-iOS
//
//  Created by Chris on 7/23/13.
//  Copyright (c) 2013 Kii. All rights reserved.
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
