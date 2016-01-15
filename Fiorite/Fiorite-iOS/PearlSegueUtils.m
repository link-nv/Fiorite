//
//  PearlSegueUtils.m
//  Fiorite
//
//  Created by Wim Vandenhaute on 01/08/14.
//  Copyright (c) 2014 Lin-k N.V. All rights reserved.
//

#import "PearlSegueUtils.h"

@implementation PearlSegueUtils

+ (void) popFadeNavigationController:(UINavigationController *)navigationController {
    
    [UIView transitionWithView:navigationController.view
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ [navigationController popViewControllerAnimated:NO]; }
                    completion:NULL];
}

+ (void) popFadeToRootViewController:(UINavigationController *)navigationController {
    
    [UIView transitionWithView:navigationController.view
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ [navigationController popToRootViewControllerAnimated:NO]; }
                    completion:NULL];
    
}

+ (void) fadeOutInReplace:(UIViewController *)viewController forWindow:(UIWindow *)window animationDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration
                     animations:^{
                         window.rootViewController.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         viewController.view.alpha                  = 0.0;
                         window.rootViewController = viewController;
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              viewController.view.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished2) {
                                          }];
                     }];

}

@end
