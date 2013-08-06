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
 Utility methods for NSMutableArray to make common functionality more efficient and reusable.
 */
@interface NSMutableArray (KTUtilities)

/**
 Shuffle the array
 
 Randomizes the order of the elements within the array in place.
 */
- (void) shuffle;

/**
 Reorganize elements in an array in place
 
 @param from The index to move the object from
 @param to The index to move the object to
 */
- (void) moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

@end
