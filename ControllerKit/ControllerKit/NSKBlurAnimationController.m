    //
//  NSKBlurAnimationController.m
//  ControllerKit
//
//  Created by Neil Kimmett on 07/10/2013.
//  Copyright (c) 2013 Neil Kimmett. All rights reserved.
//

#import "NSKBlurAnimationController.h"

@implementation NSKBlurAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.7;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    
    [self animateTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView {
    
    // Add the toView to the container
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:containerView.bounds];
    [containerView insertSubview:toolbar aboveSubview:toView];
    
    toView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    
    fromView.backgroundColor = [UIColor clearColor];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromView.alpha = 0.0;
        toolbar.alpha = 0.0;
        toView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        fromView.transform = CGAffineTransformMakeScale(1.6, 1.6);
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            fromView.alpha = 1.0;
        }
        else {
            [fromView removeFromSuperview];
            fromView.alpha = 1.0;
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
