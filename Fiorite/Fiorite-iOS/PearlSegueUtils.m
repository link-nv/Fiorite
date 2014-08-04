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

@end
