//
//  PearlFadeSegue.m
//  Fiorite
//
//  Created by Wim Vandenhaute on 01/08/14.
//  Copyright (c) 2014 Lin-k N.V. All rights reserved.
//

#import "PearlFadeSegue.h"

@implementation PearlFadeSegue

-(void)perform {
    
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.25;
    transition.type = kCATransitionFade;
    
    [[self.sourceViewController navigationController].view.layer addAnimation:transition forKey:kCATransition];
    [[self.sourceViewController navigationController] pushViewController:[self destinationViewController] animated:NO];
}

+ (void) fade:(UIViewController *)vc into:(UINavigationController *)navVC {
    
    [PearlFadeSegue fade:vc into:navVC withDuration:0.25];

}

+ (void) fade:(UIViewController *)vc into:(UINavigationController *)navVC withDuration:(CFTimeInterval)duration {

    CATransition* transition = [CATransition animation];
    
    transition.duration = duration;
    transition.type = kCATransitionFade;
    
    [navVC.view.layer addAnimation:transition forKey:kCATransition];
    [navVC pushViewController:vc animated:NO];

}

@end
