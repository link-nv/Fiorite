//
//  UILabel+MultiLineAutoSize.h
//  Fiorite
//
//  Created by Wim Vandenhaute on 25/09/13.
//  Copyright (c) 2013 Lin-k N.V. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Auto adjust font size for multi line UILabel's
 * From: http://stackoverflow.com/questions/9059631/autoshrink-on-a-uilabel-with-multiple-lines
 */
@interface UILabel (MultiLineAutoSize)

- (void)adjustFontSizeToFit;

@end
