//
//  NSURL+Additions.m
//  Fiorite
//
//  Created by Wim Vandenhaute on 25/11/13.
//  Copyright (c) 2013 Lin-k N.V. All rights reserved.
//

#import "PearlImports.h"

@implementation NSURL (Additions)

- (NSURL *) URLByAppendingQueryString:(NSString *)queryString {
    if (![queryString length]) {
        return self;
    }
    
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@", [self absoluteString],
                           [self query] ? @"&" : @"?", queryString];
    return [NSURL URLWithString:URLString];
}

- (NSURL *) URLByAppendingXCallback:(PearlXCallback *)xCallback {

    NSURL *callbackUrl = [self URLByAppendingQueryString:PearlString(@"%@=%@", X_CB_SOURCE, [xCallback.xSource encodeURL])];
    if (nil != xCallback.xSuccess)
        callbackUrl = [callbackUrl URLByAppendingQueryString:PearlString(@"%@=%@", X_CB_SUCCESS, [xCallback.xSuccess encodeURL])];
    if (nil != xCallback.xError)
        callbackUrl = [callbackUrl URLByAppendingQueryString:PearlString(@"%@=%@", X_CB_ERROR, [xCallback.xError encodeURL])];
    if (nil != xCallback.xCancel)
        callbackUrl = [callbackUrl URLByAppendingQueryString:PearlString(@"%@=%@", X_CB_CANCEL, [xCallback.xCancel encodeURL])];
    return callbackUrl;
}

@end
