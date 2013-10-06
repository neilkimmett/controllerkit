//
//  NSKIntroViewController.m
//  ControllerKit
//
//  Created by Neil Kimmett on 06/10/2013.
//  Copyright (c) 2013 Neil Kimmett. All rights reserved.
//

#import "NSKIntroViewController.h"
#import "NSKControllerViewController.h"

@interface NSKIntroViewController () <UICollisionBehaviorDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, assign) BOOL hasController;
@end

@implementation NSKIntroViewController

#pragma mark - View controller config
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    CGRect frame = self.view.bounds;
    
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.backgroundColor = [UIColor clearColor];
    questionLabel.textAlignment = NSTextAlignmentCenter;
    questionLabel.textColor = [UIColor blackColor];
    questionLabel.text = @"Hello there. Do you have an iOS7 compatible game controller?";
    questionLabel.font = [UIFont systemFontOfSize:18];
    questionLabel.numberOfLines = 0;
    [self.view addSubview:questionLabel];
    
    UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeSystem];
    yesButton.translatesAutoresizingMaskIntoConstraints = NO;
    [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [yesButton addTarget:self action:@selector(didTapYesButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yesButton];
    
    UIButton *noButton = [UIButton buttonWithType:UIButtonTypeSystem];
    noButton.translatesAutoresizingMaskIntoConstraints = NO;
    [noButton setTitle:@"No" forState:UIControlStateNormal];
    [noButton addTarget:self action:@selector(didTapNoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noButton];

    questionLabel.frame = CGRectMake(20, CGRectGetMidY(frame)-50, CGRectGetWidth(frame) - 20, 70);

    CGFloat xMargin = 80;
    yesButton.frame = CGRectMake(xMargin, CGRectGetMaxY(questionLabel.frame) + 10, 50, 30);
    noButton.frame = CGRectMake(CGRectGetMaxX(frame)-xMargin-50, CGRectGetMinY(yesButton.frame), CGRectGetWidth(yesButton.frame), CGRectGetHeight(yesButton.frame));
    
    self.items = @[questionLabel, yesButton, noButton];
}

- (void)addDynamicAnimatorWithItems:(NSArray *)items
{
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.animator = animator;
    
    UICollisionBehavior *collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:items];
    collisionBehaviour.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehaviour.collisionDelegate = self;
    [animator addBehavior:collisionBehaviour];
//    self.collisionBehaviour = collisionBehaviour;
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:items];

    UIDynamicBehavior *compoundBehaviour = [[UIDynamicBehavior alloc] init];
    [compoundBehaviour addChildBehavior:gravityBehaviour];

    for (UIView *item in items) {

        UIPushBehavior *pushBehaviour = [[UIPushBehavior alloc] initWithItems:@[item] mode:UIPushBehaviorModeInstantaneous];
        NSInteger oneOrMinusOne = -1+2*arc4random_uniform(2);
        [pushBehaviour setAngle:oneOrMinusOne*M_PI magnitude:0.7];

        [compoundBehaviour addChildBehavior:pushBehaviour];
    }
    [animator addBehavior:compoundBehaviour];
}

#pragma mark - Buttons
- (void)didTapYesButton:(UIButton *)button
{
    _hasController = YES;
    button.tintColor = [UIColor greenColor];
    [self addDynamicAnimatorWithItems:self.items];
}

- (void)didTapNoButton:(UIButton *)button
{
    _hasController = NO;
    button.tintColor = [UIColor greenColor];
    [self addDynamicAnimatorWithItems:self.items];
}

#pragma mark - UICollisionBehaviorDelegate
- (void)collisionBehavior:(UICollisionBehavior *)behavior
      beganContactForItem:(id <UIDynamicItem>)item
   withBoundaryIdentifier:(id <NSCopying>)identifier
                  atPoint:(CGPoint)p
{
    // if boundary is near bottom of view
    if (p.y >= CGRectGetMaxY(self.view.frame) - 100) {
        [self performSelector:@selector(initiateStage2AndRemoveBehaviour:) withObject:behavior afterDelay:1.0];
    }
}

#pragma mark - Stage 2
- (void)initiateStage2AndRemoveBehaviour:(UIDynamicBehavior *)behaviour
{
    [self.animator removeBehavior:behaviour];
    if (_hasController) {
        // do something
    }
    else {
        NSKControllerViewController *viewController = [[NSKControllerViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
