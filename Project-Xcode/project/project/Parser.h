//
//  Parser.h
//  TutorialOne
//
//  Created by Shaheem Khan on 2014-09-11.
//  Copyright (c) 2014 Shaheem Khan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject <NSXMLParserDelegate>
{
    NSXMLParser *parser;
    NSMutableString *element;
}

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString *)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary*)attributeDict;

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString *)string;

@end