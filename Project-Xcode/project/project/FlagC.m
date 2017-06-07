//
//  NSObject+Flag.m
//  project
//
//  Created by Shaheem Khan on 2014-11-28.
//  Copyright (c) 2014 Shaheem Khan. All rights reserved.
//

#import "FlagC.h"

@implementation FlagC

@synthesize connection;
@synthesize parserString;
@synthesize currentNodeContent;

NSXMLParser     *parser;
NSString *s;



- (NSString*)flag:(Comment *)p  {
    NSString *cid  = [[p primaryID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    s = [NSString stringWithFormat: @"http://localhost:8080/social/flagC?id=%@", cid];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *a = [defaults objectForKey:@"flagsC"];
    if (a == nil) {
        a = [[NSMutableArray alloc] init];
        NSMutableArray *iden =  [[NSMutableArray alloc] init];
        [iden addObject: cid];
        [a addObject: iden];
        [defaults setObject:a forKey:@"flagsC"];
        [defaults synchronize];
        NSString *emptyString = @"";
        const char *utfString = [emptyString UTF8String];
        dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
        [self startReceive];
        return @"YES";
    }
    
    if (a != nil) {
        if (![a containsObject: cid]) {
            NSString *emptyString = @"";
            const char *utfString = [emptyString UTF8String];
            dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
            [self startReceive];
            [a addObject: cid];
            [defaults setObject:a forKey:@"flagsC"];
            [defaults synchronize];
            return @"YES";
        }
    }
    
    return @"NO";
}




- (BOOL)isReceiving
{
    return (self.connection != nil);
}

- (void)startReceive
// Starts a connection to download the current URL.
{
    BOOL    success;
    NSURL * url;
    NSURLRequest *  request;
    
    assert(self.connection == nil);        // don't tap receive twice in a row!
    
    // First get and check the URL.
    NSLog(@"\n\n\n%@", s);
    url = [[NetworkManager sharedInstance] smartURLForString: s];
    success = (url != nil);
    
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    
    if ( ! success) {
        //self.textField.text  = @"Invalid URL";
        NSLog(@"Invalid URL");
    }
    else {
        
        // Open a connection for the URL.
        
        request = [NSURLRequest requestWithURL:url];
        assert(request != nil);
        
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
        assert(self.connection != nil);
        
        // Tell the UI we're receiving.
        
        [self receiveDidStart];
    }
}

- (void)receiveDidStart
{
    NSLog(@"Receiving");
    //self.textField.text  = @"Receiving";
    [[NetworkManager sharedInstance] didStartNetworkOperation];
}


- (void)receiveDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        statusString = @"GET succeeded";
    }
    //self.textField.text  = statusString;
    NSLog(@"%@", statusString);
    [[NetworkManager sharedInstance] didStopNetworkOperation];
    
    NSMutableString  *displayString = [NSMutableString stringWithString: @"XML=====\n" ];
    [displayString appendString:
     [[NSString alloc] initWithData:dataRead encoding:NSASCIIStringEncoding]];
    
    
    //[displayString appendString: [[NSString alloc] initWithData:dataRead encoding:NSASCIIStringEncoding]];
    
    
    //http://www.theappcodeblog.com/2011/05/09/parsing-xml-in-an-iphone-app-tutorial/
    parser = [[NSXMLParser alloc] initWithData:dataRead];
    parser.delegate = self;
    [parser parse];
    //  [displayString appendString:  parserString];
    NSLog(@"%@", parserString);
    
    [displayString appendString: @"\nEnd Processing =====\n"];
    //self.textView.text = displayString;
    NSLog(@"%@",displayString);
}

- (void)stopReceiveWithStatus:(NSString *)statusString
{
    if (self.connection != nil) {
        [self.connection cancel];
        self.connection = nil;
    }
    
    [self receiveDidStopWithStatus:statusString];
    
}

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
// A delegate method called by the NSURLConnection when the request/response
// exchange is complete.  We look at the response to check that the HTTP
// status code is 2xx and that the Content-Type is acceptable.  If these checks
// fail, we give up on the transfer.
{
    NSHTTPURLResponse * httpResponse;
    NSString *          contentTypeHeader;
    
    assert(theConnection == self.connection);
    
    httpResponse = (NSHTTPURLResponse *) response;
    assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
    
    if ((httpResponse.statusCode / 100) != 2) {
        [self stopReceiveWithStatus:[NSString stringWithFormat:@"HTTP error %zd", (ssize_t) httpResponse.statusCode]];
    } else {
        contentTypeHeader = [httpResponse MIMEType];
        if (contentTypeHeader == nil) {
            [self stopReceiveWithStatus:@"No Content-Type!"];
        } else if ( ! [contentTypeHeader isEqual:@"text/html"] || [contentTypeHeader isEqual:@"text/xml"]) {
        } else {
            //self.textField.text  = @"Response OK.";
            NSLog( @"Response OK.");
        }
    }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
// A delegate method called by the NSURLConnection as data arrives.
{
    assert(theConnection == self.connection);
    
    [dataRead appendData: data];
    
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
// A delegate method called by the NSURLConnection if the connection fails.
// We shut down the connection and display the failure.  Production quality code
// would either display or log the actual error.
{
    assert(theConnection == self.connection);
    
    [self stopReceiveWithStatus:@"Connection failed"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
// A delegate method called by the NSURLConnection when the connection has been
// done successfully.  We shut down the connection with a nil status, which
// causes the image to be displayed.
{
    assert(theConnection == self.connection);
    
    [self stopReceiveWithStatus:nil];
}


- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if ([elementname isEqualToString:@"stuff"])
    {
        [parserString appendString:elementname];
        [parserString appendString:@"\n"];
    }
}

//http://www.theappcodeblog.com/2011/05/09/parsing-xml-in-an-iphone-app-tutorial/
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementname isEqualToString:@"flagsC"])
    {
        
        NSLog(@"\n\n\n\n %@", currentNodeContent);
        [parserString appendString:elementname];
        [parserString appendString:@"-->"];
        [parserString appendString:currentNodeContent];
        [parserString appendString:@"\n"];
    }
    else {
        [parserString appendString:@"BAD: "];
        [parserString appendString:elementname];
        [parserString appendString:@"-->"];
        [parserString appendString:currentNodeContent];
        [parserString appendString:@"\n"];
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end
