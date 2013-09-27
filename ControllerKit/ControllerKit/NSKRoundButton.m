//
//  NSKRoundButton.m
//  ControllerKit
//
//  Created by Neil Kimmett on 27/09/2013.
//  Copyright (c) 2013 Neil Kimmett. All rights reserved.
//

#import "NSKRoundButton.h"

@implementation NSKRoundButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.opaque = NO;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    NSArray *colors = @[(id)self.fillColor.CGColor, (id)[self gradientHighlightColor].CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, NULL);
   
    CGContextSaveGState(ctx);
    
    if (self.rounded) {
        CGContextAddEllipseInRect(ctx, rect);
        CGContextClip(ctx);
    }
    
    CGPoint gradientEnd = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(ctx, gradient, CGPointZero, gradientEnd, 0);
    CGContextRestoreGState(ctx);
    
    CGColorSpaceRelease(space);
    CGGradientRelease(gradient);
}


@end
