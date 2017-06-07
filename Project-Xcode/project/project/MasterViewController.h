//
//  MasterViewController.h
//  project
//
//  Created by Shaheem Khan on 2014-11-12.
//  Copyright (c) 2014 Shaheem Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Flag.h"

@class DetailViewController;


@interface MasterViewController : UITableViewController <NSXMLParserDelegate> {
    NSMutableData *dataRead;
    NSMutableArray *searchResults;
}

@property (nonatomic, strong, readwrite) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableString  *parserString;
@property (nonatomic, retain) NSMutableString *currentNodeContent;
@property Post* p;
@property Flag* f;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property IBOutlet UIBarButtonItem *sortByLabel;
@property IBOutlet UIBarButtonItem *refresh;
@property IBOutlet UISearchBar *searchBar;

@end

