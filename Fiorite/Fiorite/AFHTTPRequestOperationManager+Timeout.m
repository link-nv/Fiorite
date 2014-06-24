//
//  AFHTTPRequestOperationManager+Timeout.m
//  Fiorite
//
//  Created by Wim Vandenhaute on 23/06/14.
//  Copyright (c) 2014 Lin-k N.V. All rights reserved.
//

#import "AFHTTPRequestOperationManager+Timeout.h"

@implementation AFHTTPRequestOperationManager (Timeout)

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                timeoutInterval:(NSTimeInterval)timeoutInterval
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    request.timeoutInterval = timeoutInterval;

    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
    
    return operation;

}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                 timeoutInterval:(NSTimeInterval)timeoutInterval
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
 
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    request.timeoutInterval = timeoutInterval;
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
    
    return operation;

    
}

@end
