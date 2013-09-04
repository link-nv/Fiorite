/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

//
//  AbstractWSController.m
//  Pearl
//
//  Created by Maarten Billemont on 04/06/09.
//  Copyright, lhunath (Maarten Billemont) 2009. All rights reserved.
//

#import "PearlWSController.h"
#import "NSDictionary_JSONExtensions.h"
#import "NSString+PearlNSArrayFormat.h"
#import "PearlLogger.h"
#import "PearlStringUtils.h"
#import "CJSONSerializer.h"
#import "NSObject+PearlExport.h"
#import <AFHTTPClient.h>
#import "PearlImports.h"

#if TARGET_OS_IPHONE
#import "PearlAlert.h"
#endif

#define JSON_NON_EXECUTABLE_PREFIX      @")]}'\n"

#define REQUEST_KEY_VERSION             @"version"


@implementation PearlJSONResult

@synthesize code = _code, outdated = _outdated;
@synthesize userDescription = _userDescription, userDescriptionArguments = _userDescriptionArguments;
@synthesize technicalDescription = _technicalDescription;
@synthesize result = _result;

- (id)initWithDictionary:(NSDictionary *)aDictionary {
    
    if (!(aDictionary == nil || (self = [super init])))
        return nil;
    
    self.code                     = [NSNullToNil([aDictionary valueForKeyPath:@"code"]) intValue];
    self.outdated                 = [NSNullToNil([aDictionary valueForKeyPath:@"outdated"]) boolValue];
    self.userDescription          = NSNullToNil([aDictionary valueForKeyPath:@"userDescription"]);
    self.userDescriptionArguments = NSNullToNil([aDictionary valueForKeyPath:@"userDescriptionArguments"]);
    self.technicalDescription     = NSNullToNil([aDictionary valueForKeyPath:@"technicalDescription"]);
    self.result                   = NSNullToNil([aDictionary valueForKeyPath:@"result"]);
    
    return self;
}

@end

@implementation PearlWSController
@synthesize suppressOutdatedWarning = _suppressOutdatedWarning;

#pragma mark ###############################
#pragma mark Lifecycle

+ (instancetype)get {
    
    static PearlWSController *instance;
    if (!instance)
        instance = [self new];
    
    return instance;
}


#pragma mark ###############################
#pragma mark Behaviors


- (NSURL *)serverURL {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"You must override this method." userInfo:nil];
}

- (void)upgrade {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"You must override this method." userInfo:nil];
}

- (BOOL)isSynchronous {
    
    return NO;
}

- (AFURLConnectionOperationSSLPinningMode) sslPinningMode {
    
    return AFSSLPinningModePublicKey;
}

- (void)reset {
    
    self.suppressOutdatedWarning = NO;
}

- (id)requestWithDictionary:(NSDictionary *)parameters method:(PearlWSRequestMethod)method
                               completion:(void (^)(NSData *responseData, NSError *connectionError))completion {
    
    trc(@"Out to %@, method: %d:\n%@", [self serverURL], method, parameters);
    
    switch (method) {
        case PearlWSRequestMethodGET_REST: {

            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:self.serverURL];
            httpClient.defaultSSLPinningMode = self.sslPinningMode;

            NSMutableString *urlString = [[self.serverURL absoluteString] mutableCopy];
            BOOL hasQuery = [urlString rangeOfString:@"?"].location != NSNotFound;

            for (NSString *key in [parameters allKeys]) {
                id value = [parameters objectForKey:key];
                if (value != [NSNull null]) {
                    [urlString appendFormat:@"%s%@=%@", hasQuery? "&": "?",
                     [key encodeURL], [[value description] encodeURL]];
                    hasQuery = YES;
                }
            }
            [urlString appendFormat:@"%s%@=%@", hasQuery? "&": "?",
             [REQUEST_KEY_VERSION encodeURL],
             [[PearlConfig get].build encodeURL]];
            
            [httpClient getPath:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

                completion(responseObject, nil);

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                completion(nil, error);
            }];

            break;
        }
        case PearlWSRequestMethodPOST_REST: {

            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:self.serverURL];
            httpClient.defaultSSLPinningMode = self.sslPinningMode;
            
            NSMutableDictionary *postParameters = [[NSMutableDictionary alloc] initWithCapacity:parameters.count + 1];
            for( NSString *key in [parameters allKeys]) {
                id value = [parameters objectForKey:key];
                [postParameters setObject:value forKey:key];
            }
            [postParameters setObject:[PearlConfig get].build forKey:REQUEST_KEY_VERSION];
            
            [httpClient postPath:[self.serverURL absoluteString] parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                completion(responseObject, nil);

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                completion(nil, error);
                
            }];
            
            break;
        }
        case PearlWSRequestMethodPOST_JSON: {
            
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:self.serverURL];
            httpClient.defaultSSLPinningMode = self.sslPinningMode;

            [httpClient setParameterEncoding:AFJSONParameterEncoding];
            
            [httpClient postPath:[self.serverURL absoluteString] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                completion(responseObject, nil);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                completion(nil, error);
                
            }];
            
            break;
        }
    }
    
    return nil;
}

- (id)requestWithObject:(id)object method:(PearlWSRequestMethod)method popupOnError:(BOOL)popupOnError
             completion:(void (^)(BOOL success, PearlJSONResult *response, NSError *connectionError))completion {
    
    return [self requestWithDictionary:[object exportToDictionary] method:method completion:^(NSData *responseData, NSError *connectionError) {
        PearlJSONResult *response = nil;
        BOOL valid = !connectionError && [self validateAndParseResponse:responseData into:&response
                                                           popupOnError:popupOnError requires:nil];
        
        completion(valid, response, connectionError);
    }];
}


- (BOOL)validateAndParseResponse:(NSData *)responseData into:(PearlJSONResult **)response popupOnError:(BOOL)popupOnError
                        requires:(NSString *)key, ... {
    
    *response = nil;
    if (responseData == nil || !responseData.length) {
#if TARGET_OS_IPHONE
        if (popupOnError)
            [PearlAlert showError:[PearlWSStrings get].errorWSConnection];
#endif
        return NO;
    }
    
    // Trim off non-executable-JSON prefix.
    if (responseData.length >= [JSON_NON_EXECUTABLE_PREFIX length] &&
        [JSON_NON_EXECUTABLE_PREFIX isEqualToString:
         [[NSString alloc] initWithData:[responseData subdataWithRange:NSMakeRange(0,
                                                                                   [JSON_NON_EXECUTABLE_PREFIX length])]
                               encoding:NSUTF8StringEncoding]])
        responseData = [responseData subdataWithRange:
                        NSMakeRange([JSON_NON_EXECUTABLE_PREFIX length],
                                    [responseData length] - [JSON_NON_EXECUTABLE_PREFIX length])];
    
    // Parse the JSON response data.
    id jsonError = nil;
    NSDictionary *resultDictionary = [NSDictionary dictionaryWithJSONData:responseData error:&jsonError];
    if (jsonError != nil) {
        err(@"JSON: %@, for response:\n%@", jsonError, [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
#if TARGET_OS_IPHONE
        if (popupOnError)
            [PearlAlert showError:[PearlWSStrings get].errorWSResponseInvalid];
#endif
        return NO;
    }
    *response = [[PearlJSONResult alloc] initWithDictionary:resultDictionary];
    if (!*response) {
#if TARGET_OS_IPHONE
        if (popupOnError)
            [PearlAlert showError:[PearlWSStrings get].errorWSResponseInvalid];
#endif
        return NO;
    }
    
    // Check whether the client is up-to-date enough.
#if TARGET_OS_IPHONE
    if (popupOnError)
        if ((*response).outdated) {
            if ((*response).code == PearlJSONResultCodeUpdateRequired)
                // Required upgrade.
                [PearlAlert showAlertWithTitle:[PearlStrings get].commonTitleError
                                       message:[PearlWSStrings get].errorWSResponseOutdatedRequired
                                     viewStyle:UIAlertViewStyleDefault
                                     initAlert:nil tappedButtonBlock:^(UIAlertView *alert, NSInteger buttonIndex) {
                                         if (buttonIndex == [alert firstOtherButtonIndex])
                                             [self upgrade];
                                     } cancelTitle:[PearlStrings get].commonButtonBack otherTitles:[PearlStrings get].commonButtonUpgrade, nil];
            else
                if (!self.suppressOutdatedWarning) {
                    // Optional upgrade.
                    [PearlAlert showAlertWithTitle:[PearlStrings get].commonTitleError
                                           message:[PearlWSStrings get].errorWSResponseOutdatedOptional
                                         viewStyle:UIAlertViewStyleDefault
                                         initAlert:nil tappedButtonBlock:^(UIAlertView *alert, NSInteger buttonIndex) {
                                             if (buttonIndex == [alert firstOtherButtonIndex])
                                                 [self upgrade];
                                         } cancelTitle:[PearlStrings get].commonButtonBack otherTitles:[PearlStrings get].commonButtonUpgrade, nil];
                    self.suppressOutdatedWarning = YES;
                }
        }
#endif
    
    if ((*response).code != PearlJSONResultCodeSuccess) {
        err(@"Result Code %d: %@", (*response).code, (*response).technicalDescription);
        
#if TARGET_OS_IPHONE
        if (popupOnError && (*response).code != PearlJSONResultCodeUpdateRequired) {
            NSString *errorMessage = (*response).userDescription;
            if (errorMessage && errorMessage.length) {
                [PearlAlert showError:[NSString stringWithFormat:PearlLocalize(errorMessage) array:(*response).userDescriptionArguments]];
            }
            else
                [PearlAlert showError:[PearlWSStrings get].errorWSResponseFailed];
        }
#endif
        
        return NO;
    }
    
    // Validate whether all required keys are set.  Keys are resolved using KVC.
    va_list args;
    va_start(args, key);
    for (NSString *nextKey = key; nextKey; nextKey = va_arg(args, NSString*)) {
        id value = nil;
        @try {
            value = NSNullToNil([(*response) valueForKeyPath:nextKey]);
        }
        @catch (NSException *e) {
        }
        
        if (!value) {
            err(@"Missing key: %@, in result: %@", nextKey, *response);
            
#if TARGET_OS_IPHONE
            if (popupOnError)
                [PearlAlert showError:[PearlWSStrings get].errorWSResponseInvalid];
#endif
            return NO;
        }
    }
    va_end(args);
    
    return YES;
}

@end
