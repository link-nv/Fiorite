//
//  PearlFadeSegue.h
//  Fiorite
//
//  Created by Wim Vandenhaute on 01/08/14.
//  Copyright (c) 2014 Lin-k N.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PearlFadeSegue : UIStoryboardSegue

+ (void) fade:(UIViewController *)vc into:(UINavigationController *)navVC;
+ (void) fade:(UIViewController *)vc into:(UINavigationController *)navVC withDuration:(CFTimeInterval)duration;

@end
