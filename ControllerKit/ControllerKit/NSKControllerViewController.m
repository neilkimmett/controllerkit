//
//  NSKViewController.m
//  ControllerKit
//
//  Created by Neil Kimmett on 11/09/2013.
//  Copyright (c) 2013 Neil Kimmett. All rights reserved.
//

#import "NSKControllerViewController.h"
#import "UIView+AutoLayout.h"
#import "SoundBankPlayer.h"
#import "NSKRoundButton.h"
#import "UIColor+LightAndDark.h"

@interface NSKControllerViewController ()
@property (nonatomic, strong) NSArray *controllerArray;
@property (nonatomic, strong) SoundBankPlayer *soundBankPlayer;
@end

@implementation NSKControllerViewController

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (id)init
{
    self = [super init];
    if (self) {
        [self setupAudioPlayer];
    }
    return self;
}

- (void)setupAudioPlayer
{
    _soundBankPlayer = [[SoundBankPlayer alloc] init];
    [_soundBankPlayer setSoundBank:@"Acoustic"];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *buttons = [NSMutableArray array];
    NSDictionary *colorsByButtonName = @{@"A": @[[UIColor redColor], UIColorFromRGB(0xd9294c)],
                                          @"B": @[[UIColor greenColor], UIColorFromRGB(0x2cdd2d)],
                                          @"X": @[[UIColor yellowColor], UIColorFromRGB(0xe9eb3a)],
                                          @"Y": @[[UIColor cyanColor], UIColorFromRGB(0x29d6f3)]};
    [colorsByButtonName enumerateKeysAndObjectsUsingBlock:^(NSString *buttonName, NSArray *colors, BOOL *stop) {
        UIButton *btn = [self buttonWithButtonName:buttonName color1:colors[0] color2:colors[1]];
        [self.view addSubview:btn];
        [buttons addObject:btn];
        
        [btn autoSetDimension:ALDimensionHeight toSize:100];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    }];
    [self.view autoDistributeSubviews:buttons alongAxis:ALAxisHorizontal withFixedSize:100 alignment:NSLayoutFormatAlignAllTop];
    
    NSKRoundButton *l = [self buttonWithButtonName:@"L" color1:[UIColor grayColor] color2:[UIColor darkGrayColor]];
    l.rounded = NO;
    NSKRoundButton *r = [self buttonWithButtonName:@"R" color1:[UIColor grayColor] color2:[UIColor darkGrayColor]];
    r.rounded = NO;
    [self.view addSubview:l];
    [self.view addSubview:r];
    [l autoSetDimensionsToSize:CGSizeMake(100, 100)];
    [r autoSetDimensionsToSize:CGSizeMake(100, 100)];
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    statusBarHeight = 20;
    [l autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:statusBarHeight];
    [r autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:statusBarHeight];
    
    [l autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [r autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
}

- (NSKRoundButton *)buttonWithButtonName:(NSString *)buttonName color1:(UIColor *)color1 color2:(UIColor *)color2
{
    NSKRoundButton *btn = [[NSKRoundButton alloc] initForAutoLayout];
    btn.fillColor = color1;
    btn.gradientHighlightColor = color2;
    btn.rounded = YES;
    [btn setTitle:buttonName forState:UIControlStateNormal];
    [btn addTarget:self
            action:NSSelectorFromString([NSString stringWithFormat:@"didTapButton%@", buttonName])
  forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)setupHandlersForController:(GCController *)controller
{
    GCExtendedGamepad *profile = controller.extendedGamepad;
    
    profile.buttonA.valueChangedHandler = ^(GCControllerButtonInput *button, float inputValue, BOOL pressed) {
        if (pressed) {
            [self didTapButtonA];
        }
    };
    profile.buttonB.valueChangedHandler = ^(GCControllerButtonInput *button, float inputValue, BOOL pressed) {
        if (pressed) {
            [self didTapButtonB];
        }
    };
    profile.buttonX.valueChangedHandler = ^(GCControllerButtonInput *button, float inputValue, BOOL pressed) {
        if (pressed) {
            [self didTapButtonX];
        }
    };
    profile.buttonY.valueChangedHandler = ^(GCControllerButtonInput *button, float inputValue, BOOL pressed) {
        if (pressed) {
            [self didTapButtonY];
        }
    };
    profile.leftShoulder.valueChangedHandler = ^(GCControllerButtonInput *button, float inputValue, BOOL pressed) {
        if (pressed) {
            [self didTapButtonL];
        }
    };
    profile.rightShoulder.valueChangedHandler = ^(GCControllerButtonInput *button, float inputValue, BOOL pressed) {
        if (pressed) {
            [self didTapButtonR];
        }
    };
}

#pragma mark - Buttons
- (void)didTapButtonA
{
    [_soundBankPlayer noteOn:1 gain:0.4f];
}

- (void)didTapButtonB
{
    [_soundBankPlayer noteOn:2 gain:0.4f];
}

- (void)didTapButtonX
{
    [_soundBankPlayer noteOn:3 gain:0.4f];
}

- (void)didTapButtonY
{
    [_soundBankPlayer noteOn:4 gain:0.4f];
}

- (void)didTapButtonL
{
    [_soundBankPlayer noteOn:5 gain:0.4f];
}

- (void)didTapButtonR
{
    [_soundBankPlayer noteOn:6 gain:0.4f];
}

@end
