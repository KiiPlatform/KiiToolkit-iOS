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

/**
 Utility methods for NSDate to make common functionality more efficient and reusable.
 */
@interface NSDate (KTUtilities)

/**
 Get a string representation of the given date
 
 Not a standard date string, but in readable format like "3 hours ago"
 
 @param shortened TRUE if the word should be shortened (i.e. 3h ago). FALSE otherwise (i.e. 3 hours ago)
 @return A string representation of the time
 */
- (NSString*) timeAgo:(BOOL)shortened;

@end
