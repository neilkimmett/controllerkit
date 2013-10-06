//
//  UIColor+LightAndDark.m
//  Food(ness)
//
//  Created by Neil Kimmett on 30/04/2013.
//  Copyright (c) 2013 Marks & Spencer. All rights reserved.
//

#import "UIColor+LightAndDark.h"

@implementation UIColor (LightAndDark)

- (UIColor *)lighterColor
{
    float h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * 1.3, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColor
{
    float h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.75
                               alpha:a];
    return self;
}
@end