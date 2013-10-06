//
//  NSKViewController.h
//  ControllerKit
//
//  Created by Neil Kimmett on 11/09/2013.
//  Copyright (c) 2013 Neil Kimmett. All rights reserved.
//

@import GameController;

#import <UIKit/UIKit.h>

@interface NSKControllerViewController : UIViewController

-(void)setupHandlersForController:(GCController *)controller;

@end
