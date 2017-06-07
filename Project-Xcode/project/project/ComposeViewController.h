//
//  UIViewController+ComposeViewController.h
//  project
//
//  Created by Shaheem Khan on 2014-11-13.
//  Copyright (c) 2014 Shaheem Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"

@interface ComposeViewController :UIViewController <NSXMLParserDelegate> {
    NSMutableData *dataRead;
}

@property (nonatomic, strong, readwrite) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableString  *parserString;
@property (nonatomic, retain) NSMutableString *currentNodeContent;

@property (nonatomic, retain) IBOutlet UITextField *titleField;
@property (nonatomic, retain) IBOutlet UILabel *l;

@end
