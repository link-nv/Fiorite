//
//  NSURL+Additions.h
//  Fiorite
//
//  Created by Wim Vandenhaute on 25/11/13.
//  Copyright (c) 2013 Lin-k N.V. All rights reserved.
//

#import "PearlImports.h"

@interface NSURL (Additions)

- (NSURL *)URLByAppendingQueryString:(NSString *)queryString;

- (NSURL *) URLByAppendingXCallback:(PearlXCallback *)xCallback;

@end
