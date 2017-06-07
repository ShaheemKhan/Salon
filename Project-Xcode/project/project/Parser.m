//
//  Parser.m
//  TutorialOne
//
//  Created by Shaheem Khan on 2014-09-11.
//  Copyright (c) 2014 Shaheem Khan. All rights reserved.
//

#import "Parser.h"

@implementation Parser

-init {
    if(self == [super init]) {
        parser = [[NSXMLParser alloc]
                  initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                                pathForResource:@"Sample" ofType: @"xml"]]];
        [parser setDelegate:self];
        [parser parse];
    }      
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary*)attributeDict    {
        NSLog(@"Started Element %@", elementName);
        element = [NSMutableString string];
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
        NSLog(@"Found an element named: %@ with a value of: %@", elementName, element);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(element == nil)
        element = [[NSMutableString alloc] init];
    [element appendString:string];
}


@end
