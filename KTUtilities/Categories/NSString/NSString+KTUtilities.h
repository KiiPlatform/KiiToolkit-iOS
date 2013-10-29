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

#import <Foundation/Foundation.h>

typedef enum {
    KTCharacterSetUppercase         = 1 << 0,
    KTCharacterSetLowercase         = 1 << 1,
    KTCharacterSetNumeric           = 1 << 2,
    KTCharacterSetAlpha             = KTCharacterSetUppercase | KTCharacterSetLowercase,
    KTCharacterSetAlphanumeric      = KTCharacterSetAlpha | KTCharacterSetNumeric
} KTCharacterSet;


/**
 Utility methods for NSString to make commonly-needed functionality more efficient and reusable.
 */
@interface NSString (KTUtilities)

/**
 Generate a random string of a given length
 
 If you'd like to control the character set, use randomString:withCharacterSet: otherwise, the default is KTCharacterSetAlphanumeric
 
 @param len The desired length of the generated string
 @return A random string with length 'len'
 */
+ (NSString*) randomString:(int)len;

/**
 Generate a random string of a given length, in a given character set
 
 @param len The desired length of the generated string
 @param charSet The character set to use to create the string
 @return A random string with length 'len'
 */
+ (NSString*) randomString:(int)len withCharacterSet:(KTCharacterSet)charSet;

/**
 A utility method to determine if a given string is contained within the responder
 
 @param needle The string we are searching for
 @return TRUE if the responder contains the needle, FALSE otherwise
 */
- (BOOL) containsString:(NSString*)needle;

/**
 A utility method to determine if a given character is contained within the responder
 
 @param needle The character we are searching for
 @return TRUE if the responder contains the needle, FALSE otherwise
 */
- (BOOL) containsCharacter:(char)needle;

/**
 Retrieve the characters within a given KTCharacterSet
 
 @param set The character set to retrieve
 @return The items within the character set
 */
+ (NSString*) charactersForSet:(KTCharacterSet)set;

- (CGFloat)fontSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
