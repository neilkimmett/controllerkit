//
//  NSKIntroViewController.m
//  ControllerKit
//
//  Created by Neil Kimmett on 06/10/2013.
//  Copyright (c) 2013 Neil Kimmett. All rights reserved.
//

@import GameController;

#import "NSKIntroViewController.h"
#import "NSKControllerViewController.h"
#import "NSKBlurAnimationController.h"

@interface NSKIntroViewController () <UICollisionBehaviorDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIDynamicAnimator *animator1;
@property (nonatomic, strong) UIDynamicAnimator *animator2;
@property (nonatomic, assign) BOOL hasController;
@end

@implementation NSKIntroViewController

- (id)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        [center addObserver:self selector:@selector(setupControllers:)
                       name:GCControllerDidConnectNotification object:nil];
        [center addObserver:self selector:@selector(setupControllers:)
                       name:GCControllerDidDisconnectNotification object:nil];

    }
    return self;
}

#pragma mark - View controller config

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];

    CGRect frame = self.view.bounds;
    
    UILabel *questionLabel = [self labelWithText:@"Hello there. Do you have an iOS7 compatible game controller?"];
    [self.view addSubview:questionLabel];
    
    UIButton *yesButton = [self buttonWithText:@"Yes" action:@selector(didTapYesButton:)];
    [self.view addSubview:yesButton];
    
    UIButton *noButton = [self buttonWithText:@"No" action:@selector(didTapNoButton:)];
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
    self.animator1 = animator;
    
    UICollisionBehavior *collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:items];
    collisionBehaviour.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehaviour.collisionDelegate = self;
    [animator addBehavior:collisionBehaviour];
    
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

#pragma mark - Constructors
- (UILabel *)labelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = text;
    label.font = [UIFont systemFontOfSize:18];
    label.numberOfLines = 0;
    return label;
}

- (UIButton *)buttonWithText:(NSString *)text action:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:text forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    return button;
}

#pragma mark - Buttons
- (void)didTapYesButton:(UIButton *)button
{
    [self didTapNoButton:button];
    return;
    
    _hasController = YES;
    button.tintColor = [UIColor greenColor];
    [self addDynamicAnimatorWithItems:self.items];
    
    [GCController startWirelessControllerDiscoveryWithCompletionHandler:^{
        [self setupControllers:nil];
    }];
}

- (void)setupControllers:(NSNotification *)notification
{
    NSArray *controllerArray = controllerArray = [GCController controllers];
    for (GCController *controller in controllerArray) {
        NSKControllerViewController *viewController = [[NSKControllerViewController alloc] init];
        [self presentViewController:viewController animated:NO completion:nil];
        [viewController setupHandlersForController:controller];
    }
}

- (void)didTapNoButton:(UIButton *)button 
{
    _hasController = NO;
    button.tintColor = [UIColor greenColor];
    [self addDynamicAnimatorWithItems:self.items];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.userInteractionEnabled = YES;
    [self.view addSubview:containerView];
    
    UILabel *dontWorryLabel = [self labelWithText:@"In which case this app will be a bit useless for you. Don't worry though friend! Let's pretend you do, by making an onscreen controller"];
    [containerView addSubview:dontWorryLabel];
    
    UIButton *okButton = [self buttonWithText:@"OK, let's do that!" action:@selector(didTapOKButton:)];
    [containerView addSubview:okButton];
    
    dontWorryLabel.frame = CGRectMake(20, 0, CGRectGetWidth(self.view.frame) - 40, 140);
    okButton.frame = CGRectMake(0, CGRectGetMaxY(dontWorryLabel.frame), CGRectGetWidth(self.view.frame), 20);
    
    CGFloat containerViewHeight = CGRectGetHeight(dontWorryLabel.frame) + CGRectGetHeight(okButton.frame);
    CGFloat containerViewYOrigin = CGRectGetMinY(self.view.frame) - containerViewHeight;
    
    // move view offscreen (to start with)
    containerView.frame = CGRectMake(0, containerViewYOrigin, CGRectGetWidth(self.view.frame), containerViewHeight);

    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.animator2 = animator;
    
    UICollisionBehavior *collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[containerView]];
    
    CGFloat boundaryYPosition = CGRectGetMidY(self.view.frame) + containerViewHeight/2.;
    CGPoint startPoint = CGPointMake(0, boundaryYPosition);
    CGPoint endPoint = CGPointMake(CGRectGetWidth(self.view.frame), boundaryYPosition);
    [collisionBehaviour addBoundaryWithIdentifier:@"NSKHalfwayBoundaryIdentifier" fromPoint:startPoint toPoint:endPoint];
    [animator addBehavior:collisionBehaviour];

    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[containerView]];
    [animator addBehavior:gravityBehaviour];
}

- (void)didTapOKButton:(UIButton *)button
{
    button.tintColor = [UIColor greenColor];
    NSKControllerViewController *viewController = [[NSKControllerViewController alloc] init];
//    [self.navigationController pushViewController:viewController animated:YES];
    viewController.transitioningDelegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - UICollisionBehaviorDelegate
- (void)collisionBehavior:(UICollisionBehavior *)behavior
      beganContactForItem:(id <UIDynamicItem>)item
   withBoundaryIdentifier:(id <NSCopying>)identifier
                  atPoint:(CGPoint)p
{
    // if boundary is near bottom of view
    if (p.y >= CGRectGetMaxY(self.view.frame) - 100) {
        [self.animator1 performSelector:@selector(removeBehavior:) withObject:behavior afterDelay:1.0];
    }
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    return [[NSKBlurAnimationController alloc] init];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[NSKBlurAnimationController alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
   return [[NSKBlurAnimationController alloc] init];
}

@end
