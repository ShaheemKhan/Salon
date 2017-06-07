//
//  NSObject+Flag.h
//  project
//
//  Created by Shaheem Khan on 2014-11-28.
//  Copyright (c) 2014 Shaheem Khan. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Post.h"
#import "NetworkManager.h"

@interface Flag : NSObject <NSXMLParserDelegate> {
    NSMutableData *dataRead;
}

- (NSString*)flag:(Post *)p ;

@property (nonatomic, strong, readwrite) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableString  *parserString;
@property (nonatomic, retain) NSMutableString *currentNodeContent;



@end
