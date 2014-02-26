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
//  PearlDeviceUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#include <sys/sysctl.h>
#import <mach-o/ldsyms.h>
#import "PearlImports.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@implementation PearlDeviceUtils

+ (NSString *)platform {
    
    size_t size;
    sysctlbyname( "hw.machine", NULL, &size, NULL, 0 );
    
    char *machine = malloc( size );
    sysctlbyname( "hw.machine", machine, &size, NULL, 0 );
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free( machine );
    
    return platform;
}

+ (BOOL)isAppEncrypted {
    
    const uint8_t *command = (const uint8_t *) (&_mh_execute_header + 1);
    for (uint32_t idx = 0; idx < _mh_execute_header.ncmds; ++idx)
        if (((const struct load_command *) command)->cmd == LC_ENCRYPTION_INFO) {
            struct encryption_info_command *crypt_cmd = (struct encryption_info_command *) command;
            return crypt_cmd->cryptid != 0;
        }
        else
            command += ((const struct load_command *) command)->cmdsize;
    
    return NO;
}

+ (BOOL)isJailbroken {
    
    return system("") == 0;
}

+ (BOOL)isIPod {
    
    return [[self platform] hasPrefix:@"iPod"];
}

+ (BOOL)isIPad {
    
#if TARGET_OS_IPHONE
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
#else
    return NO;
#endif
}

+ (BOOL)isIPhone {
    
    return [[self platform] hasPrefix:@"iPhone"];
}

+ (BOOL) isLandscape {
    
#if TARGET_OS_IPHONE
    return [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight;
#else
    return NO;
#endif
}

+ (BOOL) is4inch {
    
#if TARGET_OS_IPHONE
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0);
#else
    return NO;
#endif
}

+ (BOOL) hasCamera {
    
#if TARGET_OS_IPHONE
    return ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]);
#else
    return NO;
#endif
}


+ (BOOL)isSimulator {
    
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

+ (float)uiScale {
    
#if TARGET_OS_IPHONE
    switch ([UIDevice currentDevice].userInterfaceIdiom) {
        case UIUserInterfaceIdiomPad:
            return 1024.0f / 480.0f;
        case UIUserInterfaceIdiomPhone:
            break;
    }
#endif
    
    return 1;
}

@end

