//
//  AFHTTPRequestOperationManager+Timeout.h
//  Fiorite
//
//  Created by Wim Vandenhaute on 23/06/14.
//  Copyright (c) 2014 Lin-k N.V. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface AFHTTPRequestOperationManager (Timeout)

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                timeoutInterval:(NSTimeInterval)timeoutInterval
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                 timeoutInterval:(NSTimeInterval)timeoutInterval
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
