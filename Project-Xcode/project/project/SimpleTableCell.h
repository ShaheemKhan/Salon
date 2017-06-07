//
//  SimpleTableCell.h
//  SimpleTable
//
//  Created by Simon Ng on 28/4/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "Post.h"

@interface SimpleTableCell : UITableViewCell <NSXMLParserDelegate> {
    NSMutableData *dataRead;
}

@property (nonatomic, strong, readwrite) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableString  *parserString;
@property (nonatomic, retain) NSMutableString *currentNodeContent;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *votesLabel;
@property (nonatomic, weak) IBOutlet UILabel *commentsLabel;
@property (nonatomic, weak) IBOutlet UIButton *agree;
@property (nonatomic, weak) IBOutlet UIButton *disagree;
@property bool buttonToggled1;
@property bool buttonToggled;
@property NSString* pid;
@property (nonatomic, retain) NSString *k;

-(IBAction) onClickAgree: (id) sender;
-(IBAction) onClickDisagree: (id) sender;

@end
