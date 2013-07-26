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

#import "KTLoaderProgressIndicator.h"

@implementation KTLoaderProgressIndicator

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _progress = 0.0;
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
    CGContextSetStrokeColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    CGContextStrokePath(contextRef);
    
    // draw filling starting at 0%.
    // must subtract pi/2 to transform starting position to top of circle
    float finalDegree = _progress*2*M_PI - M_PI/2;
    CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius, -M_PI/2, finalDegree, 0);
    CGContextClosePath(contextRef);
    CGContextFillPath(contextRef);
}

- (void)setProgress:(double)value {
    _progress = value;
    NSLog(@"Value: %g", value);
    NSLog(@"Progress: %g", value);
    if (_progress <= 1.0) {
        [self setNeedsDisplay];
    }
}

@end
