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
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "NSKDPadButton.h"

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
    
    NSMutableDictionary *buttonsByName = [NSMutableDictionary dictionary];
    NSDictionary *colorsByButtonName = @{@"A": @[[UIColor redColor], UIColorFromRGB(0xd9294c)],
                                          @"B": @[[UIColor greenColor], UIColorFromRGB(0x2cdd2d)],
                                          @"X": @[[UIColor yellowColor], UIColorFromRGB(0xe9eb3a)],
                                          @"Y": @[[UIColor cyanColor], UIColorFromRGB(0x29d6f3)]};
    [colorsByButtonName enumerateKeysAndObjectsUsingBlock:^(NSString *buttonName, NSArray *colors, BOOL *stop) {
        UIButton *btn = [self buttonWithButtonName:buttonName color1:colors[0] color2:colors[1]];
        [self.view addSubview:btn];
        buttonsByName[buttonName] = btn;
        
        [btn autoSetDimensionsToSize:CGSizeMake(100, 100)];
    }];
    
    [buttonsByName[@"Y"] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [buttonsByName[@"B"] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [buttonsByName[@"X"] autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:buttonsByName[@"Y"]];
    [buttonsByName[@"A"] autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:buttonsByName[@"B"]];
    
    [buttonsByName[@"X"] autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [buttonsByName[@"Y"] autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [buttonsByName[@"A"] autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:buttonsByName[@"X"]];
    [buttonsByName[@"B"] autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:buttonsByName[@"Y"]];
    
    NSKRoundButton *l1 = [self buttonWithButtonName:@"L1" color1:[UIColor blackColor] color2:[UIColor darkGrayColor]];
    l1.rounded = NO;
    NSKRoundButton *r1 = [self buttonWithButtonName:@"R1" color1:[UIColor blackColor] color2:[UIColor darkGrayColor]];
    r1.rounded = NO;
    [self.view addSubview:l1];
    [self.view addSubview:r1];
    [l1 autoSetDimensionsToSize:CGSizeMake(100, 100)];
    [r1 autoSetDimensionsToSize:CGSizeMake(100, 100)];
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    statusBarHeight = 20;
    [l1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:statusBarHeight];
    [r1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:statusBarHeight];
    
    [l1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [r1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    
    NSKRoundButton *l2 = [self buttonWithButtonName:@"L2" color1:[UIColor grayColor] color2:[UIColor darkGrayColor]];
    l2.rounded = NO;
    NSKRoundButton *r2 = [self buttonWithButtonName:@"R2" color1:[UIColor grayColor] color2:[UIColor darkGrayColor]];
    r2.rounded = NO;
    [self.view addSubview:l2];
    [self.view addSubview:r2];
    [l2 autoSetDimensionsToSize:CGSizeMake(120, 80)];
    [r2 autoSetDimensionsToSize:CGSizeMake(120, 80)];
    
    [l2 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:statusBarHeight];
    [r2 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:statusBarHeight];
    
    CGFloat hairline = 1. / [[UIScreen mainScreen] scale];
    
    [l2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:l1 withOffset:hairline];
    [r2 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:r1 withOffset:-hairline];
    
    NSKDPadButton *dPadButton = [[NSKDPadButton alloc] initForAutoLayout];
    [self.view addSubview:dPadButton];
    [dPadButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
    [dPadButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [dPadButton autoSetDimension:ALDimensionWidth toSize:30];
    [dPadButton autoSetDimension:ALDimensionHeight toSize:100];
    
    
    UILabel *settingsButtonLabel = [[UILabel alloc] initForAutoLayout];
    settingsButtonLabel.userInteractionEnabled = YES;
    settingsButtonLabel.font = [UIFont iconicFontOfSize:20];
    settingsButtonLabel.textColor = [UIColor darkGrayColor];
    settingsButtonLabel.highlightedTextColor = [UIColor grayColor];
    settingsButtonLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-cogs"];
    [self.view addSubview:settingsButtonLabel];
    
    UITapGestureRecognizer *settingsGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(didTapSettingsButton:)];
    [settingsButtonLabel addGestureRecognizer:settingsGestureRecognizer];
    
    [settingsButtonLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:statusBarHeight];
    [settingsButtonLabel autoCenterInSuperviewAlongAxis:ALAxisVertical];
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
            [self didTapButtonL1];
        }
    };
    profile.rightShoulder.valueChangedHandler = ^(GCControllerButtonInput *button, float inputValue, BOOL pressed) {
        if (pressed) {
            [self didTapButtonR1];
        }
    };
    profile.leftTrigger.valueChangedHandler = ^(GCControllerButtonInput *button, float inputValue, BOOL pressed) {
        if (pressed) {
            [self didTapButtonL2];
        }
    };
    profile.rightTrigger.valueChangedHandler = ^(GCControllerButtonInput *button, float inputValue, BOOL pressed) {
        if (pressed) {
            [self didTapButtonR2];
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

- (void)didTapButtonL1
{
    [_soundBankPlayer noteOn:5 gain:0.4f];
}

- (void)didTapButtonR1
{
    [_soundBankPlayer noteOn:6 gain:0.4f];
}

- (void)didTapButtonL2
{
    [_soundBankPlayer noteOn:7 gain:0.4f];
}

- (void)didTapButtonR2
{
    [_soundBankPlayer noteOn:8 gain:0.4f];
}

- (void)didTapSettingsButton:(UITapGestureRecognizer *)gesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
