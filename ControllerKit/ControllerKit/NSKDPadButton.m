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
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor darkGrayColor] setFill];

    
    // draw triangle
    CGContextMoveToPoint(ctx, 0, CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextFillPath(ctx);
}


@end
