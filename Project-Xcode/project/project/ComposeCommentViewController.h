//
//  UIViewController+ComposeViewController.h
//  project
//
//  Created by Shaheem Khan on 2014-11-13.
//  Copyright (c) 2014 Shaheem Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "Post.h"

@interface ComposeCommentViewController :UIViewController <NSXMLParserDelegate> {
    NSMutableData *dataRead;
}

@property (nonatomic, strong, readwrite) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableString  *parserString;
@property (nonatomic, retain) NSMutableString *currentNodeContent;
@property (strong, nonatomic) Post* detailItem;
@property (nonatomic, retain) IBOutlet UITextView *titleField;

@end
