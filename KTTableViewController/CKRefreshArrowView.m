// CKRefreshArrowView.m
// 
// Copyright (c) 2012 Instructure, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "CKRefreshArrowView.h"
#import <QuartzCore/QuartzCore.h>

#if !__has_feature(objc_arc)
#error Add -fobjc-arc to the compile flags for CKRefreshArrowView.m
#endif

@implementation CKRefreshArrowView {
    BOOL _rotated;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

static void commonSetup(CKRefreshArrowView *self) {
    self.tintColor = [UIColor colorWithWhite:0.5 alpha:1];
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        commonSetup(self);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    commonSetup(self);
}

- (void)setTintColor:(UIColor *)tintColor {
    if (tintColor == nil) {
        tintColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    }
    _tintColor = tintColor;
    [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (void)drawRect:(CGRect)rect {
    [self updateShapeLayerPath];
    [super drawRect:rect];
}

- (void)updateShapeLayerPath {

    self.shapeLayer.fillColor = _tintColor.CGColor;
    
    CGFloat effectiveProgress = MIN(self.progress, 1.0);
    CGFloat arrowWidth = 8.0f;
    CGFloat baseWidth = 6.0f;
    CGFloat arrowHeight = 12.0f;
    CGFloat verticalPadding = 6.0f;
    CGFloat horizPadding = 12.0f;
    
    // Start constructing the path
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // draw a triangle for the arrowhead
    CGPoint tip = CGPointMake(horizPadding + baseWidth/2, self.bounds.size.height - verticalPadding);
    CGPoint left = CGPointMake(tip.x-arrowWidth, tip.y-arrowHeight);
    CGPoint right = CGPointMake(tip.x+arrowWidth, tip.y-arrowHeight);
    
    [path moveToPoint:tip];
    [path addLineToPoint:left];
    [path addLineToPoint:right];
    
    // create a line from the base of the arrow
    CGPoint baseLeft = CGPointMake(horizPadding, left.y);
    [path moveToPoint:baseLeft];
    
    CGPoint topLeft = CGPointMake(horizPadding, verticalPadding);
    [path addLineToPoint:topLeft];
    
    CGPoint topRight = CGPointMake(horizPadding + baseWidth, verticalPadding);
    [path addLineToPoint:topRight];

    CGPoint baseRight = CGPointMake(horizPadding + baseWidth, right.y);
    [path addLineToPoint:baseRight];

    self.shapeLayer.path = [path CGPath];
    
    CGFloat animationDuration = 0.2f;
    if(effectiveProgress >= 1.0 && !_rotated) {
        _rotated = TRUE;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
        pathAnimation.duration = animationDuration;
        pathAnimation.fromValue = @(0.0f);
        pathAnimation.toValue = @(M_PI);
        pathAnimation.repeatCount = 0;
        pathAnimation.removedOnCompletion = FALSE;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.autoreverses = NO;
        [self.shapeLayer addAnimation:pathAnimation forKey:@"transform.rotation.x"];
    } else if(effectiveProgress < 1.0 && _rotated) {
        _rotated = FALSE;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
        pathAnimation.duration = animationDuration;
        pathAnimation.fromValue = @(M_PI);
        pathAnimation.toValue = @(0.0);
        pathAnimation.repeatCount = 0;
        pathAnimation.removedOnCompletion = FALSE;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.autoreverses = NO;
        [self.shapeLayer addAnimation:pathAnimation forKey:@"transform.rotation.x"];
    }
    
}

@end
