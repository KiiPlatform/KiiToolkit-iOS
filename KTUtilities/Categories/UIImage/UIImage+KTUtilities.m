//
//  UIImage+KTExtensions.m
//  MyPix
//
//  Created by Chris on 7/25/13.
//  Copyright (c) 2013 Kii. All rights reserved.
//

#import "UIImage+KTUtilities.h"

@implementation UIImage (KTUtilities)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    // scale to fill
    CGFloat wAspect = newSize.width / image.size.width;
    CGFloat hAspect = newSize.height / image.size.height;
    
    CGFloat aspect = MAX(hAspect, wAspect);
    newSize = CGSizeMake(image.size.width*aspect, image.size.height*aspect);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
