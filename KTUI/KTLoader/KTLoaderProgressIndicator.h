//
//  KTLoaderProgressIndicator.h
//  MyPix
//
//  Created by Chris on 7/25/13.
//  Copyright (c) 2013 Kii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTLoaderProgressIndicator : UIView

@property (readwrite) float currentValue;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *fillColor;

- (void)setProgress:(double)value;

@end
