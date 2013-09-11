//
//  NSKViewController.m
//  ControllerKit
//
//  Created by Neil Kimmett on 11/09/2013.
//  Copyright (c) 2013 Neil Kimmett. All rights reserved.
//

@import GameController;

#import "NSKViewController.h"
#import "UIView+AutoLayout.h"
#import "SoundBankPlayer.h"

@interface NSKViewController ()
@property (nonatomic, strong) NSArray *controllerArray;
@property (nonatomic, strong) SoundBankPlayer *soundBankPlayer;
@end

@implementation NSKViewController

- (id)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        
        [center addObserver:self selector:@selector(setupControllers:)
                        name:GCControllerDidConnectNotification object:nil];
        [center addObserver:self selector:@selector(setupControllers:)
                        name:GCControllerDidDisconnectNotification object:nil];
        [self setupAudioPlayer];
    }
    return self;
}

- (void)setupAudioPlayer
{
    _soundBankPlayer = [[SoundBankPlayer alloc] init];
    [_soundBankPlayer setSoundBank:@"Acoustic"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *connectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    connectButton.frame = CGRectMake(100, 100, 100, 100);
    [connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    [self.view addSubview:connectButton];
    
    [connectButton addTarget:self
                      action:@selector(didTapConnectButton:)
            forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *buttons = [NSMutableArray array];
    for (NSString *buttonName in @[@"A", @"B", @"X", @"Y"]) {
        UIButton *btn = [self buttonWithButtonName:buttonName];
        [self.view addSubview:btn];
        [buttons addObject:btn];
        
        [btn autoSetDimension:ALDimensionHeight toSize:100];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    }
    [self.view autoDistributeSubviews:buttons alongAxis:ALAxisHorizontal withFixedSize:100 alignment:NSLayoutFormatAlignAllTop];
    
    UIButton *l = [self buttonWithButtonName:@"L"];
    UIButton *r = [self buttonWithButtonName:@"R"];
    [self.view addSubview:l];
    [self.view addSubview:r];
//    [l autoSetDimension:ALDimensionHeight toSize:100];
    [l autoSetDimensionsToSize:CGSizeMake(100, 100)];
    [r autoSetDimensionsToSize:CGSizeMake(100, 100)];
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    statusBarHeight = 20;
    [l autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:statusBarHeight];
    [r autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:statusBarHeight];
    
    [l autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [r autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
//    [self.view autoDistributeSubviews:@[l, r] alongAxis:ALAxisHorizontal withFixedSize:100 alignment:NSLayoutFormatAlignAllTop];
}

- (UIButton *)buttonWithButtonName:(NSString *)buttonName
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [btn setTitle:buttonName forState:UIControlStateNormal];
    [btn addTarget:self
            action:NSSelectorFromString([NSString stringWithFormat:@"didTapButton%@", buttonName])
  forControlEvents:UIControlEventTouchUpInside];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    return btn;
}

- (void)setupControllers:(NSNotification *)notification
{
    self.controllerArray = [GCController controllers];
    for (GCController *controller in self.controllerArray) {
        [self setupHandlersForController:controller];
    }
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
    [_soundBankPlayer queueNote:1 gain:0.4f];
    [_soundBankPlayer playQueuedNotes];
}

- (void)didTapButtonB
{
    [_soundBankPlayer queueNote:2 gain:0.4f];
    [_soundBankPlayer playQueuedNotes];
}

- (void)didTapButtonX
{
    [_soundBankPlayer queueNote:3 gain:0.4f];
    [_soundBankPlayer playQueuedNotes];
}

- (void)didTapButtonY
{
    [_soundBankPlayer queueNote:4 gain:0.4f];
    [_soundBankPlayer playQueuedNotes];
}

- (void)didTapButtonL
{
    [_soundBankPlayer queueNote:5 gain:0.4f];
    [_soundBankPlayer playQueuedNotes];
}

- (void)didTapButtonR
{
    [_soundBankPlayer queueNote:6 gain:0.4f];
    [_soundBankPlayer playQueuedNotes];
}

#pragma mark - Button actions
- (void)didTapConnectButton:(UIButton *)button
{
    [GCController startWirelessControllerDiscoveryWithCompletionHandler:^{
        [self setupControllers:nil];
    }];
}

@end
