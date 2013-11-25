//
//  PearlXCallback.m
//  Fiorite
//
//  Created by Wim Vandenhaute on 25/11/13.
//  Copyright (c) 2013 Lin-k N.V. All rights reserved.
//

#import "PearlImports.h"

@implementation PearlXCallback

-(id) initWithSource:(NSString *)xSource withSuccess:(NSString *)xSuccess withError:(NSString *)xError withCancel:(NSString *)xCancel {

    if (!(self = [super init]))
        return self;
    
    self.xSource    = xSource;
    self.xSuccess   = xSuccess;
    self.xError     = xError;
    self.xCancel    = xCancel;
    
    return self;
}

- (id) initWithQueryString:(NSString *)queryString {

    if (!(self = [super init]))
        return self;
    
    dbg(@"Query string: %@", queryString);
    
    NSMutableDictionary *dict = [queryString parseQueryString];
    self.xSource = [dict objectForKey:@"x-source"];
    self.xSuccess = [dict objectForKey:@"x-success"];
    self.xError = [dict objectForKey:@"x-error"];
    self.xCancel = [dict objectForKey:@"x-cancel"];
    
    return self;
}

- (NSString *)description {
    
    return PearlString(@"x-source=%@, x-success=%@, x-error=%@, x-cancel=%@", self.xSource, self.xSuccess, self.xError, self.xCancel);
}

@end
