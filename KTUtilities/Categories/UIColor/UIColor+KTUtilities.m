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

#import "UIColor+KTUtilities.h"

@implementation UIColor (KTUtilities)

#pragma mark - Color Creation Methods
+ (UIColor*) colorWithHex:(NSString*)hex
{
    
    // default to black
    UIColor *color = [UIColor blackColor];
    
    // make sure the method receives a proper parameter
    if(hex != nil) {
                
        // convert to uppercase for simplicity
        hex = [hex uppercaseString];
        
        // and remove any leading Ox's
        hex = [hex stringByReplacingOccurrencesOfString:@"0X" withString:@""];
        
        // we want to match the following formats:
        // RGB, RRGGBB, RRGGBBAA
        NSString *pattern = @"^(?=[0-9A-F]*$)(?:.{3}|.{6}|.{8})$";
        
        // run the regular expression on our hex string
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:0
                                                                                 error:&error];
        
        // ensure the regex worked properly
        if(error == nil) {
            
            // get the matched range
            NSRange range = [regex rangeOfFirstMatchInString:hex options:0 range:NSMakeRange(0, hex.length)];

            // if location was found, we have a match
            if(range.location != NSNotFound) {
                
                // set some defaults
                NSString *rString = @"00";
                NSString *gString = @"00";
                NSString *bString = @"00";
                NSString *aString = @"FF";
                
                // if the string is of the format RGB, convert into RRGGBB
                if(hex.length == 3) {
                    NSString *newR = [hex substringWithRange:NSMakeRange(0, 1)];
                    NSString *newG = [hex substringWithRange:NSMakeRange(1, 1)];
                    NSString *newB = [hex substringWithRange:NSMakeRange(2, 1)];
                    
                    rString = [newR stringByAppendingString:newR];
                    gString = [newG stringByAppendingString:newG];
                    bString = [newB stringByAppendingString:newB];
                }
                
                // otherwise we have the format RRGGBB or RRGGBBAA, so set accordingly
                else {
                    rString = [hex substringWithRange:NSMakeRange(0, 2)];
                    gString = [hex substringWithRange:NSMakeRange(2, 2)];
                    bString = [hex substringWithRange:NSMakeRange(4, 2)];
                    
                    // the method has been passed an alpha component, parse it
                    if(hex.length == 8) {
                        aString = [hex substringWithRange:NSMakeRange(6, 2)];
                    }
                }

                // scan the hex values into some integers
                unsigned int r, g, b, a;
                [[NSScanner scannerWithString:rString] scanHexInt:&r];
                [[NSScanner scannerWithString:gString] scanHexInt:&g];
                [[NSScanner scannerWithString:bString] scanHexInt:&b];
                [[NSScanner scannerWithString:aString] scanHexInt:&a];

                // finally, build the color
                color = [UIColor colorWithRed:((float) r / 255.0f)
                                        green:((float) g / 255.0f)
                                         blue:((float) b / 255.0f)
                                        alpha:((float) a / 255.0f)];
                
            }
        }

    }
        
    return color;
    
}

+ (UIColor*) randomColor
{
    CGFloat r = ((float)(arc4random() % 256) / 255.f);
    CGFloat g = ((float)(arc4random() % 256) / 255.f);
    CGFloat b = ((float)(arc4random() % 256) / 255.f);
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
}


@end
