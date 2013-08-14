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
 Utility methods for NSArray to make common functionality more efficient and reusable.
 */
@interface NSArray (KTUtilities)

/**
 A quick method to check an object's existence within an array
 
 @return TRUE if the object exists within the array, FALSE otherwise
 */
- (BOOL) inArray:(id)value;

@end