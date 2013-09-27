//
//  NSKRoundButton.h
//  ControllerKit
//
//  Created by Neil Kimmett on 27/09/2013.
//  Copyright (c) 2013 Neil Kimmett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSKRoundButton : UIButton

@property (nonatomic, assign) BOOL rounded;

@property (nonatomic, retain) UIColor *fillColor;
@property (nonatomic, retain) UIColor *gradientHighlightColor;

@end
