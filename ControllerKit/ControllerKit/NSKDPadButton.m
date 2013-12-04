//
//  NSKDPadButton.m
//  ControllerKit
//
//  Created by Neil Kimmett on 04/12/2013.
//  Copyright (c) 2013 Neil Kimmett. All rights reserved.
//

#import "NSKDPadButton.h"

@implementation NSKDPadButton

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // draw background
    [[UIColor darkGrayColor] setFill];
    
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:3];
    CGContextAddPath(ctx, bgPath.CGPath);
    CGContextFillPath(ctx);
    
    [[UIColor lightGrayColor] setFill];
    
    // draw triangle (equilateral bitches)
    CGFloat sideLength = CGRectGetWidth(rect) * 0.5;
    CGFloat halfSideLength = 0.5 * sideLength;
    CGFloat xLeft = (CGRectGetWidth(rect) - sideLength) / 2.;
    CGFloat xRight = CGRectGetWidth(rect) - xLeft;
    CGFloat yTop = xLeft;
    CGFloat yBottom = yTop + sqrtf(sideLength*sideLength - halfSideLength*halfSideLength);
    
    CGContextMoveToPoint(ctx, xLeft, yBottom);
    CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), yTop);
    CGContextAddLineToPoint(ctx, xRight, yBottom);
    CGContextFillPath(ctx);
}


@end
