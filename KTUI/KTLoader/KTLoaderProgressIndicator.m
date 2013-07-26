//
//  KTLoaderProgressIndicator.m
//  MyPix
//
//  Created by Chris on 7/25/13.
//  Copyright (c) 2013 Kii. All rights reserved.
//

#import "KTLoaderProgressIndicator.h"

@implementation KTLoaderProgressIndicator

@synthesize currentValue,lineColor,fillColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        lineColor = [UIColor whiteColor];
        fillColor = [UIColor whiteColor];
        currentValue = 0.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextClearRect(contextRef, rect);
        
    // inner loading circle is 80% of background circle
    float radius = (rect.size.width/2.0) * 0.80;
    CGPoint center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
    
    // draw circle stroke
    CGContextSetLineWidth(contextRef, 2.0);
    CGContextAddArc(contextRef, center.x, center.y, radius, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(contextRef, [lineColor CGColor]);
    CGContextStrokePath(contextRef);
    
    // draw filling starting at 0%.
    // must subtract pi/2 to transform starting position to top of circle
    float finalDegree = currentValue*2*M_PI - M_PI/2;
    CGContextSetFillColorWithColor(contextRef, [fillColor CGColor]);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius, -M_PI/2, finalDegree, 0);
    CGContextClosePath(contextRef);
    CGContextFillPath(contextRef);
}

- (void)setProgress:(double)value {
    currentValue = value;
    if (currentValue <= 1.0) {
        [self setNeedsDisplay];
    }
}

- (void)setLineColor:(UIColor *)newLineColor {
    lineColor = newLineColor;
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)newFillColor {
    fillColor = newFillColor;
    [self setNeedsDisplay];
}

@end
