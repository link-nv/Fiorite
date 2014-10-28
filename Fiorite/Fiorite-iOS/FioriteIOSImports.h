//
//  FioriteIOSImports.h
//  Fiorite
//
//  Created by Wim Vandenhaute on 04/09/13.
//  Copyright (c) 2013 Lin-k N.V. All rights reserved.
//

#import "PearlAlert.h"
#import "PearlAppDelegate.h"
#import "PearlSheet.h"
#import "PearlBoxView.h"
#import "PearlUIUtils.h"
#import "UIImage+PearlScaling.h"
#import "NSString+Email.h"
#import "PearlImageUtils.h"
#import "PearlSegueUtils.h"

#define IS_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define IS_IOS6 [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0
#define NOT_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0
