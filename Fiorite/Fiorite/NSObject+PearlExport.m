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
//  NSObject+PearlExport.m
//  RedButton
//
//  Created by Maarten Billemont on 16/06/11.
//  Copyright 2011 Lyndir. All rights reserved.
//

#import <objc/runtime.h>
#import "PearlImports.h"

@implementation NSObject(PearlExport)

- (id<NSCoding, NSCopying>)exportToCodable {
    
    return [NSObject exportToCodable:self];
}

- (NSDictionary *)exportToDictionary {
    
    return [NSObject exportToDictionary:self];
}

+ (id<NSCoding, NSCopying>)exportToCodable:(id)object {
    
    // nil to NSNull.
    if (!object)
        return [NSNull null];
    
    // NSCoding compliant object.
    if ([object conformsToProtocol:@protocol(NSCoding)]) {
        
        // Check collections to make sure their elements are compliant.
        if ([object isKindOfClass:[NSArray class]]) {
            BOOL codable = YES;
            for (NSObject *child in object)
                if (![child conformsToProtocol:@protocol(NSCoding)]) {
                    codable = NO;
                    break;
                }
            if (!codable) {
                NSMutableArray *codableObject = [NSMutableArray arrayWithCapacity:[(NSArray *)object count]];
                for (NSObject *child in object)
                    [codableObject addObject:[self exportToCodable:child]];
                object = codableObject;
            }
        }
        if ([object isKindOfClass:[NSSet class]]) {
            BOOL codable = YES;
            for (NSObject *child in object)
                if (![child conformsToProtocol:@protocol(NSCoding)]) {
                    codable = NO;
                    break;
                }
            if (!codable) {
                NSMutableSet *codableObject = [NSMutableSet setWithCapacity:[(NSSet *)object count]];
                for (NSObject *child in object)
                    [codableObject addObject:[self exportToCodable:child]];
                object = codableObject;
            }
        }
        if ([object isKindOfClass:[NSDictionary class]]) {
            BOOL codable = YES;
            for (NSObject *key in object)
                if (![key conformsToProtocol:@protocol(NSCoding)] ||
                    ![[(NSDictionary *)object objectForKey:key] conformsToProtocol:@protocol(NSCoding)]) {
                    codable = NO;
                    break;
                }
            if (!codable) {
                NSMutableDictionary *codableObject = [NSMutableDictionary dictionaryWithCapacity:[(NSDictionary *)object count]];
                for (NSObject *key in object)
                    [codableObject setObject:[self exportToCodable:[(NSDictionary *)object objectForKey:key]]
                                      forKey:[self exportToCodable:key]];
                object = codableObject;
            }
        }
        
        return object;
    }
    
    // Not-NSCoding compliant object: NSDictionary of properties.
    return [self exportToDictionary:object];
}

+ (NSDictionary *)exportToDictionary:(id)object {
    
    if ([object isKindOfClass:[NSDictionary class]])
        return object;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (Class hierarchyClass = [object class]; [hierarchyClass superclass]; hierarchyClass = [hierarchyClass superclass]) {
        unsigned int propertiesCount;
        objc_property_t *properties = class_copyPropertyList( hierarchyClass, &propertiesCount );
        
        for (NSUInteger p = 0; p < propertiesCount; p++) {
            objc_property_t property = properties[p];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName( property ) encoding:NSUTF8StringEncoding];
            
            id propertyValue = [self exportToCodable:[object valueForKey:propertyName]];
            [dictionary setObject:propertyValue forKey:propertyName];
        }
        
        free( properties );
    }
    
    return dictionary;
}

@end

