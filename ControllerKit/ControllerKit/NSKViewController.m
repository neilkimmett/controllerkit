//
//  NSKViewController.m
//  ControllerKit
//
//  Created by Neil Kimmett on 11/09/2013.
//  Copyright (c) 2013 Neil Kimmett. All rights reserved.
//

@import GameController;

#import "NSKViewController.h"

@interface NSKViewController ()
@property (nonatomic, strong) NSArray *controllerArray;
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *connectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    connectButton.frame = CGRectMake(100, 100, 100, 100);
    [connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    [self.view addSubview:connectButton];
    
    [connectButton addTarget:self
                      action:@selector(didTapConnectButton:)
            forControlEvents:UIControlEventTouchUpInside];
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
    
    profile.rightTrigger.valueChangedHandler = ^(GCControllerButtonInput *button, float inputValue, BOOL pressed) {
        if (pressed) {
        }
    };
}

#pragma mark - Button actions
- (void)didTapConnectButton:(UIButton *)button
{
    [GCController startWirelessControllerDiscoveryWithCompletionHandler:^{
        [self setupControllers:nil];
    }];
}

@end
