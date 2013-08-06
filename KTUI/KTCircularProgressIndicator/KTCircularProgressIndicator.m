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

#import "KTCircularProgressIndicator.h"

@implementation KTCircularProgressIndicator

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // set our defaults
        _progress = 0.0;
        _strokeColor = [UIColor whiteColor];
        _fillColor = [UIColor whiteColor];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextClearRect(contextRef, rect);
        
    float radius = (rect.size.width/2.0) * 0.80;
    CGPoint center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
    
    CGContextSetLineWidth(contextRef, 2.0);
    CGContextAddArc(contextRef, center.x, center.y, radius, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(contextRef, _strokeColor.CGColor);
    CGContextStrokePath(contextRef);
    
    float finalDegree = _progress * 2 * M_PI - M_PI / 2;
    CGContextSetFillColorWithColor(contextRef, _fillColor.CGColor);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius, -1 * M_PI / 2, finalDegree, 0);
    CGContextClosePath(contextRef);
    CGContextFillPath(contextRef);
}

// override the setter to re-draw our indicator
- (void)setProgress:(double)value {
    _progress = value;
    if (_progress <= 1.0) {
        [self setNeedsDisplay];
    }
}

@end
