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
 A set of utilities that assist you with determining network connectivity status and other networking features.
 */
@interface KTNetworkingUtilities : NSObject

/**
 Determines whether or not the device has a valid network connection
 
 It's useful to check this method sometimes before you display or perform network-related functions.
 
 @return TRUE if there is a valid connection, FALSE otherwise
 */
+ (BOOL) hasConnection;

// TODO: add other methods that specify connection types

@end
