//
//  NSString+Email.m
//  Fiorite
//
//  Created by Wim Vandenhaute on 26/02/14.
//  Copyright (c) 2014 Lin-k N.V. All rights reserved.
//

#import "NSString+Email.h"

@implementation NSString (Email)

- (BOOL) isValidEmail {
    
    // ripped from http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios
    
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]*";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
