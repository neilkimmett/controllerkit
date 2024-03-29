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
@property (nonatomic, strong) UIView *fakeControllerView;
@property (nonatomic, strong) UIView *drumSoundNamesView;
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
    
    UIView *fakeControllerView = [[UIView alloc] initForAutoLayout];
    [self.view addSubview:fakeControllerView];
    [fakeControllerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.fakeControllerView = fakeControllerView;
    
    UIView *drumSoundNamesView = [[UIView alloc] initForAutoLayout];
    [self.view addSubview:drumSoundNamesView];
    [drumSoundNamesView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.drumSoundNamesView = drumSoundNamesView;
    
//    self.drumSoundNamesView.hidden = YES;
    // TODO: disable
    
    NSMutableDictionary *buttonsByName = [NSMutableDictionary dictionary];
    NSDictionary *colorsByButtonName = @{@"A": @[[UIColor redColor], UIColorFromRGB(0xd9294c)],
                                          @"B": @[[UIColor greenColor], UIColorFromRGB(0x2cdd2d)],
                                          @"X": @[[UIColor yellowColor], UIColorFromRGB(0xe9eb3a)],
                                          @"Y": @[[UIColor cyanColor], UIColorFromRGB(0x29d6f3)]};
    [colorsByButtonName enumerateKeysAndObjectsUsingBlock:^(NSString *buttonName, NSArray *colors, BOOL *stop) {
        UIButton *btn = [self buttonWithButtonName:buttonName color1:colors[0] color2:colors[1]];
        [self.fakeControllerView addSubview:btn];
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
    [self.fakeControllerView addSubview:l1];
    [self.fakeControllerView addSubview:r1];
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
    [self.fakeControllerView addSubview:l2];
    [self.fakeControllerView addSubview:r2];
    [l2 autoSetDimensionsToSize:CGSizeMake(120, 80)];
    [r2 autoSetDimensionsToSize:CGSizeMake(120, 80)];
    
    [l2 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:statusBarHeight];
    [r2 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:statusBarHeight];
    
    CGFloat hairline = 1. / [[UIScreen mainScreen] scale];
    
    [l2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:l1 withOffset:hairline];
    [r2 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:r1 withOffset:-hairline];
    
    [self buildDPad];
    
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

#pragma mark - View building
- (void)buildDPad
{
    CGFloat buttonLength = 80;
    CGFloat buttonWidth = 60;
    CGFloat padding = 20;

    NSKDPadButton *upButton = [[NSKDPadButton alloc] initForAutoLayout];
    [self.fakeControllerView addSubview:upButton];
    [upButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:padding + buttonLength];
    [upButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:padding + buttonLength - buttonWidth/2.];
    [upButton autoSetDimension:ALDimensionWidth toSize:buttonWidth];
    [upButton autoSetDimension:ALDimensionHeight toSize:buttonLength];
    
    NSKDPadButton *downButton = [[NSKDPadButton alloc] initForAutoLayout];
    [self.fakeControllerView addSubview:downButton];
    [downButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:padding];
    [downButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:padding + buttonLength - buttonWidth/2.];
    [downButton autoSetDimension:ALDimensionWidth toSize:buttonWidth];
    [downButton autoSetDimension:ALDimensionHeight toSize:buttonLength];
    downButton.transform = CGAffineTransformMakeRotation(M_PI);
    
    NSKDPadButton *rightButton = [[NSKDPadButton alloc] initForAutoLayout];
    [self.fakeControllerView addSubview:rightButton];
    [rightButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:padding + buttonLength - buttonWidth/2.];
    [rightButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:padding + buttonLength];
    [rightButton autoSetDimension:ALDimensionWidth toSize:buttonWidth];
    [rightButton autoSetDimension:ALDimensionHeight toSize:buttonLength];
    rightButton.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    NSKDPadButton *leftButton = [[NSKDPadButton alloc] initForAutoLayout];
    [self.fakeControllerView addSubview:leftButton];
    [leftButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:padding + buttonLength - buttonWidth/2.];
    [leftButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:padding];
    [leftButton autoSetDimension:ALDimensionWidth toSize:buttonWidth];
    [leftButton autoSetDimension:ALDimensionHeight toSize:buttonLength];
    leftButton.transform = CGAffineTransformMakeRotation(3*M_PI_2);
}

#pragma mark - Button handlers
-(void)setupHandlersForController:(GCController *)controller
{
    self.fakeControllerView.hidden = YES;
    self.drumSoundNamesView.hidden = NO;
    
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

#pragma mark - Sound playing
- (void)didTapButtonA
{
    [_soundBankPlayer noteOn:1 gain:0.4f];
    [self showDrumNameForName:@"Kick"];
}

- (void)didTapButtonB
{
    [_soundBankPlayer noteOn:2 gain:0.4f];
    [self showDrumNameForName:@"Snare"];
}

- (void)didTapButtonX
{
    [_soundBankPlayer noteOn:3 gain:0.4f];
    [self showDrumNameForName:@"Tom 1"];
}

- (void)didTapButtonY
{
    [_soundBankPlayer noteOn:4 gain:0.4f];
    [self showDrumNameForName:@"Tom 2"];
}

- (void)didTapButtonL1
{
    [_soundBankPlayer noteOn:5 gain:0.4f];
    [self showDrumNameForName:@"Hi-hat (open)"];
}

- (void)didTapButtonR1
{
    [_soundBankPlayer noteOn:6 gain:0.4f];
    [self showDrumNameForName:@"Hi-hat (closed)"];
}

- (void)didTapButtonL2
{
    [_soundBankPlayer noteOn:7 gain:0.4f];
    [self showDrumNameForName:@"Pd-Hat (what?)"];
}

- (void)didTapButtonR2
{
    [_soundBankPlayer noteOn:8 gain:0.4f];
    [self showDrumNameForName:@"Hi-hat (again)"];
}

#pragma mark - Drum name displaying
- (void)showDrumNameForName:(NSString *)name
{
    UILabel *drumNameLabel = [[UILabel alloc] init];
    drumNameLabel.backgroundColor = [UIColor clearColor];
    drumNameLabel.font = [UIFont systemFontOfSize:26];
    drumNameLabel.textColor = [UIColor blackColor];
    drumNameLabel.text = name;
    drumNameLabel.frame = self.drumSoundNamesView.bounds;
    [self.drumSoundNamesView addSubview:drumNameLabel];
    
    [UIView animateWithDuration:0.5 delay:0.2 options:0 animations:^{
        drumNameLabel.frame = CGRectInset(self.drumSoundNamesView.bounds, 200, 200);
        drumNameLabel.alpha = 0.0;
    } completion:nil];
}


#pragma mark - Settings

- (void)didTapSettingsButton:(UITapGestureRecognizer *)gesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
