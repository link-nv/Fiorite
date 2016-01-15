//
//  PearlSegueUtils.h
//  Fiorite
//
//  Created by Wim Vandenhaute on 01/08/14.
//  Copyright (c) 2014 Lin-k N.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PearlSegueUtils : NSObject

+ (void) popFadeNavigationController:(UINavigationController *)navigationController;
+ (void) popFadeToRootViewController:(UINavigationController *)navigationController;

/*
 * Replace the root view controller with a fade out fade in animation
 */
+ (void) fadeOutInReplace:(UIViewController *)viewController forWindow:(UIWindow *)window animationDuration:(NSTimeInterval)duration;

@end
