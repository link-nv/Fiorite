//
//  NSString+HTML.h
//  Fiorite
//
//  Created by Wim Vandenhaute on 25/10/13.
//  Copyright (c) 2013 Lin-k N.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTML)

- (NSString*)stripHtml;             // strip html
- (NSString*)stripHtmlWithNewLines; // strip html and replace <br> with newline

@end
