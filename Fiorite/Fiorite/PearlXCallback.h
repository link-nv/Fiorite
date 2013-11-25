//
//  PearlXCallback.h
//  Fiorite
//
//  Created by Wim Vandenhaute on 25/11/13.
//  Copyright (c) 2013 Lin-k N.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#define X_CB_SOURCE     @"x-source"
#define X_CB_SUCCESS    @"x-success"
#define X_CB_ERROR      @"x-error"
#define X_CB_CANCEL     @"x-cancel"

@interface PearlXCallback : NSObject

@property (nonatomic, strong) NSString                  *xSource;
@property (nonatomic, strong) NSString                  *xSuccess;
@property (nonatomic, strong) NSString                  *xError;
@property (nonatomic, strong) NSString                  *xCancel;

- (id) initWithSource:(NSString *)xSource withSuccess:(NSString *)xSuccess withError:(NSString *)xError withCancel:(NSString *)xCancel;
- (id) initWithQueryString:(NSString *)queryString;

@end
