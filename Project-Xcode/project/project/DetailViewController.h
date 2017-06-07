//
//  DetailViewController.h
//  project
//
//  Created by Shaheem Khan on 2014-11-12.
//  Copyright (c) 2014 Shaheem Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <QuartzCore/QuartzCore.h>
#import "Comment.h"
#import "ComposeCommentViewController.h"
#import "FlagC.h"

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,NSXMLParserDelegate> {
    NSMutableData *dataRead;
}


@property (strong, nonatomic) Post* detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property(nonatomic, strong) IBOutlet UITableView *tableView1;
@property (nonatomic, strong, readwrite) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableString  *parserString;
@property (nonatomic, retain) NSMutableString *currentNodeContent;
@property Comment* c;
@property bool buttonToggled1;
@property bool buttonToggled;
@property (nonatomic, retain) NSString *k;
@property NSString* cid;
@property FlagC* f;





@end

