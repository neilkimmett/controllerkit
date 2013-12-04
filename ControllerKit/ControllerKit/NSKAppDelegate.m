//
//  NSKAppDelegate.m
//  ControllerKit
//
//  Created by Neil Kimmett on 11/09/2013.
//  Copyright (c) 2013 Neil Kimmett. All rights reserved.
//

#import "NSKAppDelegate.h"
#import "NSKControllerViewController.h"
#import "NSKIntroViewController.h"

@implementation NSKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.tintColor = [UIColor redColor];

    NSKControllerViewController *viewController = [[NSKControllerViewController alloc] init];
//    NSKIntroViewController *viewController = [[NSKIntroViewController alloc] init];
    
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
//    navController.navigationBarHidden = YES;
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
