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

@interface NSString (KTUtilities)

+ (NSString*) randomString:(int)len;
+ (NSString*) randomString:(int)len withCharacterSet:(KTCharacterSet)charSet;

- (BOOL) containsString:(NSString*)needle;
- (BOOL) containsCharacter:(char)needle;

+ (NSString*) charactersForSet:(KTCharacterSet)set;

@end
