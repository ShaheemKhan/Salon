//
//  NetworkManager.h
//  Social-f-2013
//
//  Created by Dwight Deugo on 13-06-12.
//  Copyright (c) 2013 Carleton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedInstance;

- (NSURL *)smartURLForString:(NSString *)str;

- (void)didStartNetworkOperation;

- (void)didStopNetworkOperation;

@end
