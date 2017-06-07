//
//  NetworkManager.m
//  Social-f-2013
//
//  Created by Dwight Deugo on 13-06-12.
//  Copyright (c) 2013 Carleton. All rights reserved.
//


#import "NetworkManager.h"

@interface NetworkManager ()

// read/write redeclaration of public read-only property

@property (nonatomic, assign, readwrite) NSUInteger networkOperationCount;

@end

@implementation NetworkManager

@synthesize networkOperationCount = _networkOperationCount;

+ (NetworkManager *)sharedInstance
{
    static dispatch_once_t  onceToken;
    static NetworkManager * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[NetworkManager alloc] init];
    });
    return sSharedInstance;
}

- (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);
    
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }
    
    return result;
}

- (void)didStartNetworkOperation
{
    // If you start a network operation off the main thread, you'll have to update this code
    // to ensure that any observers of this property are thread safe.
    assert([NSThread isMainThread]);
    self.networkOperationCount += 1;
}

- (void)didStopNetworkOperation
{
    // If you stop a network operation off the main thread, you'll have to update this code
    // to ensure that any observers of this property are thread safe.
    assert([NSThread isMainThread]);
    assert(self.networkOperationCount > 0);
    self.networkOperationCount -= 1;
}

@end
