//
//  NSString+HTML.m
//  Fiorite
//
//  Created by Wim Vandenhaute on 25/10/13.
//  Copyright (c) 2013 Lin-k N.V. All rights reserved.
//

#import "NSString+HTML.h"

@interface NSString_stripHtml_XMLParsee : NSObject<NSXMLParserDelegate> {
    
@private
    NSMutableArray* strings;
    
}

- (NSString*)getCharsFound;

@end

@implementation NSString_stripHtml_XMLParsee

- (id)init {
    
    if((self = [super init])) {
        
        strings = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {
    
    [strings addObject:string];
}

- (NSString*)getCharsFound {
    
    return [strings componentsJoinedByString:@""];
}

@end

@implementation NSString (HTML)

- (NSString*)stripHtml {
    
    //Wrap it in a root element to ensure only a single root element exists
    NSString* string = [NSString stringWithFormat:@"<root>%@</root>", self];
    
    //Add the string to the xml parser
    NSStringEncoding encoding = string.fastestEncoding;
    NSData* data = [string dataUsingEncoding:encoding];
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
    
    //Parse the content keeping track of any chars found outside tags (this will be the stripped content)
    NSString_stripHtml_XMLParsee* parsee = [[NSString_stripHtml_XMLParsee alloc] init];
    parser.delegate = parsee;
    [parser parse];
    
    //Any chars found while parsing are the stripped content
    NSString* strippedString = [parsee getCharsFound];
    
    //Get the raw text out of the parsee after parsing, and return it
    return strippedString;
}

- (NSString *)stripHtmlWithNewLines {
    
    NSMutableString *outString;
    NSString *inputString = self;
    
    if (inputString) {
        outString = [[NSMutableString alloc] initWithString:inputString];
        
        // replace <br> with newlines
        [outString replaceOccurrencesOfString:@"<br>" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, inputString.length)];
        
        if ([inputString length] > 0) {
            NSRange r;
            
            while ((r = [outString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
                [outString deleteCharactersInRange:r];
            }
        }
    }
    
    return outString;
}

@end

