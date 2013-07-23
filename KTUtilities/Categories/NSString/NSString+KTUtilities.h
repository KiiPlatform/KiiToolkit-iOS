//
//  NSString+KTUtilities.h
//  KiiToolkit-iOS
//
//  Created by Chris on 7/23/13.
//  Copyright (c) 2013 Kii. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KTCharacterSetUppercase         = 1 << 0,
    KTCharacterSetLowercase         = 1 << 1,
    KTCharacterSetNumeric           = 1 << 2,
    KTCharacterSetAlpha             = KTCharacterSetUppercase | KTCharacterSetLowercase,
    KTCharacterSetAlphanumeric      = KTCharacterSetAlpha | KTCharacterSetNumeric
} KTCharacterSet;

@interface NSString (KTUtilities)

+ (NSString*) randomString:(int)len;
+ (NSString*) randomString:(int)len withCharacterSet:(KTCharacterSet)charSet;

- (BOOL) containsString:(NSString*)needle;
- (BOOL) containsCharacter:(char)needle;

+ (NSString*) charactersForSet:(KTCharacterSet)set;

@end
