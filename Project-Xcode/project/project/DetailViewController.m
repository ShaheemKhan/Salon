//
//  DetailViewController.m
//  project
//
//  Created by Shaheem Khan on 2014-11-12.
//  Copyright (c) 2014 Shaheem Khan. All rights reserved.
//

#import "DetailViewController.h"
#import "NetworkManager.h"

@interface DetailViewController ()

@end

@implementation DetailViewController {
    NSMutableArray *comments;
}

@synthesize tableView1;
@synthesize connection;
@synthesize parserString;
@synthesize currentNodeContent;
static NSString * DefaultGetURLText;
NSXMLParser     *parser;
int start;
int end;
NSString *type;
@synthesize c;
int composeBool;
@synthesize buttonToggled1;
@synthesize buttonToggled;
@synthesize k;
int vote;
@synthesize cid;
UIButton *upVoteButton;
UIButton *downVoteButton;
@synthesize f;


- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureView];
    self.navigationController.toolbarHidden=NO;

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *a = [defaults objectForKey:@"infoOpened"];
    a = [[NSMutableArray alloc] init];
    [defaults setObject:a forKey:@"infoOpened"];
    [defaults synchronize];
    
    NSMutableArray *b = [defaults objectForKey:@"liked"];
    b = [[NSMutableArray alloc] init];
    [defaults setObject:a forKey:@"liked"];
    [defaults synchronize];
    
    end = 25;
    start = 0;
    type = @"n";
    composeBool = 0;
    
    NSString *emptyString = @"";
    const char *utfString = [emptyString UTF8String];
    dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
    [self startReceive];
    vote = 0;
    f = [[FlagC alloc] init];

}


- (void)viewDidAppear:(BOOL)animated {
    if (composeBool == 1)
        [self updateList];
}

-(void)viewDidLayoutSubviews
{
    if ([tableView1 respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView1 setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView1 respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView1 setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        NSMutableString * string = [@"" mutableCopy];
        [string appendString: [self.detailItem title]];
        [string appendString: @"\n"];
        [string  appendString:   [@"Votes: " stringByAppendingString: [self.detailItem votes]]];
        [string appendString: @"\n"];
        [string  appendString: [[self.detailItem comments] stringByAppendingString: @" Comments"]];
        [string appendString: @"\n"];
        [string  appendString: [@"Posted at: " stringByAppendingString: [self.detailItem time]]];
        self.detailDescriptionLabel.text = string;
    }
}

- (UIFont *)fontForCell
{
    return [UIFont systemFontOfSize: [UIFont systemFontSize]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [[comments objectAtIndex:indexPath.row] title];

    UIFont *cellFont = [self fontForCell];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    
    CGRect labelSize = [cellText boundingRectWithSize:constraintSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:cellFont}
                                         context:nil];
    
    CGSize size = labelSize.size;
    
    if ((size.height + 20) < 80)
        return  80;
    else
        return size.height + 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [self fontForCell];
    }
    
    cell.tag = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *a = [defaults objectForKey:@"infoOpened"];
    NSNumber* n = [NSNumber numberWithInteger: indexPath.row];

    if ([a containsObject: n]) {
        cell.textLabel.text=@"";
        int height;
        NSString *cellText = [[comments objectAtIndex:indexPath.row] title];
        UIFont *cellFont = [self fontForCell];
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        
        CGRect labelSize = [cellText boundingRectWithSize:constraintSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:cellFont}
                                                  context:nil];
        
        CGSize size = labelSize.size;
        
        if ((size.height + 20) < 80)
            height = 80;
        else
            height = size.height + 20;
        
        upVoteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        upVoteButton.frame = CGRectMake( 0.0f, 5.0f, 400.0f/4, (height-9)/2);
        upVoteButton.backgroundColor = [UIColor whiteColor];
        [upVoteButton setTitle:@"△" forState:UIControlStateNormal];
        upVoteButton.titleLabel.textColor = [UIColor whiteColor];
        upVoteButton.layer.borderWidth = 1.0f;
        upVoteButton.layer.borderColor=[[UIColor blackColor] CGColor];
        [upVoteButton addTarget:self action:@selector(up:) forControlEvents:UIControlEventTouchUpInside];
        upVoteButton.tag = indexPath.row;
        [cell.contentView addSubview:upVoteButton];
        
        downVoteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        downVoteButton.frame = CGRectMake( 400.0f/4, 5.0f, 400.0f/4, (height-9)/2);
        downVoteButton.backgroundColor = [UIColor whiteColor];
        [downVoteButton setTitle:@"▽" forState:UIControlStateNormal];
        downVoteButton.titleLabel.textColor = [UIColor whiteColor];
        downVoteButton.layer.borderWidth = 1.0f;
        downVoteButton.layer.borderColor=[[UIColor blackColor] CGColor];
        [downVoteButton addTarget:self action:@selector(down:) forControlEvents:UIControlEventTouchUpInside];
        downVoteButton.tag = indexPath.row;
        [cell.contentView addSubview:downVoteButton];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *a = [defaults objectForKey:@"votedCommentsOnArray"];
        
        
        if (a != nil) {
            for (int x = 0; x < [a count]; x++) {
                NSMutableArray *ls = [a objectAtIndex: x];
                if ([[[comments objectAtIndex:indexPath.row ]title] isEqualToString: [ls objectAtIndex:0]] && [[[comments objectAtIndex:indexPath.row ]time] isEqualToString: [ls objectAtIndex:1]]) {
                    if ([@"up" isEqualToString: [ls objectAtIndex:2]]) {
                        [upVoteButton setTitle:@"▲" forState:UIControlStateNormal];
                        [downVoteButton setTitle:@"▽" forState:UIControlStateNormal];
                    }
                    if ([@"down" isEqualToString: [ls objectAtIndex:2]]) {
                        [downVoteButton setTitle:@"▼" forState:UIControlStateNormal];
                        [upVoteButton setTitle:@"△" forState:UIControlStateNormal];
                    }
                }
            }
        }
        
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        infoButton.frame = CGRectMake( 400.0f/2, 5.0f, 400.0f/4, (height-9)/2);
        infoButton.backgroundColor = [UIColor whiteColor];
        infoButton.titleLabel.textColor = [UIColor whiteColor];
        infoButton.layer.borderWidth = 1.0f;
        infoButton.layer.borderColor=[[UIColor blackColor] CGColor];
        [infoButton addTarget:self action:@selector(info:) forControlEvents:UIControlEventTouchUpInside];
        infoButton.tag = indexPath.row;
        [cell.contentView addSubview:infoButton];
        
        UIButton *flag = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        flag.frame = CGRectMake( 300.0f, 5.0f, (400.0f/4)-25, (height-9)/2);
        [flag setTitle:@"Flag" forState:UIControlStateNormal];
        flag.backgroundColor = [UIColor whiteColor];
        flag.titleLabel.textColor = [UIColor whiteColor];
        flag.layer.borderWidth = 1.0f;
        flag.layer.borderColor=[[UIColor blackColor] CGColor];
        [flag addTarget:self action:@selector(flag:) forControlEvents:UIControlEventTouchUpInside];
        flag.tag = indexPath.row;
        [cell.contentView addSubview:flag];
        
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        back.frame = CGRectMake( 0.0f, (height)/2, 400.0f - 25, ((height)/2));
        [back setTitle:@"Back" forState:UIControlStateNormal];
        back.backgroundColor = [UIColor whiteColor];
        back.titleLabel.textColor = [UIColor whiteColor];
        back.layer.borderWidth = 1.0f;
        back.layer.borderColor=[[UIColor blackColor] CGColor];
        [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        back.tag = indexPath.row;
        [cell.contentView addSubview:back];
        
        [tableView1 deselectRowAtIndexPath:indexPath animated:NO];
        cell.tag = 1;
        return cell;

    }
    else {
        NSArray* subviews = cell.contentView.subviews;
        for (UIView* subview in subviews) {
            [subview removeFromSuperview];
        }
        cell.textLabel.text = [[comments objectAtIndex: indexPath.row] title];
        [tableView1 deselectRowAtIndexPath:indexPath animated:NO];
        cell.tag = 0;
        return cell;
    }
}

- (void)up:(UIButton *)button {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];

    vote = 1;
    cid = [[comments objectAtIndex: indexPath.row] primaryID];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *a = [defaults objectForKey:@"votedCommentsOnArray"];
    if (a == nil) {
        a = [[NSMutableArray alloc] init];
        [defaults setObject:a forKey:@"votedCommentsOnArray"];
        [defaults synchronize];
    }
    NSMutableArray * upOn = [[NSMutableArray alloc] initWithObjects: [[comments objectAtIndex:indexPath.row ] title], [[comments objectAtIndex:indexPath.row ] time], @"up", nil];
    NSMutableArray * downOn = [[NSMutableArray alloc] initWithObjects: [[comments objectAtIndex:indexPath.row ] title], [[comments objectAtIndex:indexPath.row ] time], @"down", nil];
    
    buttonToggled = [a containsObject:upOn];
    buttonToggled1 = [a containsObject: downOn];
    
    if (!buttonToggled && !buttonToggled1) {
        [button setTitle:@"▲" forState:UIControlStateNormal];
        buttonToggled = YES;
        k = @"up";
        NSString *emptyString = @"";
        const char *utfString = [emptyString UTF8String];
        dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
        [self startReceive];
        
        NSMutableArray * new = [[NSMutableArray alloc] initWithArray: a];
        [new addObject: upOn];
        [defaults setObject:new forKey:@"votedCommentsOnArray"];
        [defaults synchronize];
    }
    
    else if (!buttonToggled && buttonToggled1) {
        [button setTitle:@"▲" forState:UIControlStateNormal];
        buttonToggled = YES;
        [downVoteButton setTitle:@"▽" forState:UIControlStateNormal];
        buttonToggled1 = NO;
        k = @"doubleup";
        NSString *emptyString = @"";
        const char *utfString = [emptyString UTF8String];
        dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
        [self startReceive];
        
        NSMutableArray * new = [[NSMutableArray alloc] initWithArray: a];
        [new removeObject: downOn];
        [new addObject: upOn];
        [defaults setObject: new forKey:@"votedCommentsOnArray"];
        [defaults synchronize];
    }
    else {
        [button setTitle:@"△" forState:UIControlStateNormal];
        buttonToggled = NO;
        k = @"down";
        NSString *emptyString = @"";
        const char *utfString = [emptyString UTF8String];
        dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
        [self startReceive];
        
        NSMutableArray * new = [[NSMutableArray alloc] initWithArray: a];
        [new removeObject: upOn];
        [defaults setObject: new forKey:@"votedCommentsOnArray"];
        [defaults synchronize];
    }
    vote = 0;
    [tableView1 reloadData];
}

- (void)down:(UIButton *)button {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];

    vote = 1;
    cid = [[comments objectAtIndex: indexPath.row] primaryID];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *a = [defaults objectForKey:@"votedCommentsOnArray"];
    if (a == nil) {
        a = [[NSMutableArray alloc] init];
        [defaults setObject:a forKey:@"votedCommentsOnArray"];
        [defaults synchronize];
    }
    NSMutableArray * upOn = [[NSMutableArray alloc] initWithObjects: [[comments objectAtIndex:indexPath.row ] title], [[comments objectAtIndex:indexPath.row ] time], @"up", nil];
    NSMutableArray * downOn = [[NSMutableArray alloc] initWithObjects: [[comments objectAtIndex:indexPath.row ] title], [[comments objectAtIndex:indexPath.row ] time], @"down", nil];
    
    
    buttonToggled = [a containsObject:upOn];
    buttonToggled1 = [a containsObject: downOn];
    
    if (!buttonToggled1 && !buttonToggled) {
        [button setTitle:@"▼" forState:UIControlStateNormal];
        buttonToggled1 = YES;
        k = @"down";
        NSString *emptyString = @"";
        const char *utfString = [emptyString UTF8String];
        dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
        [self startReceive];
        
        NSMutableArray * new = [[NSMutableArray alloc] initWithArray: a];
        [new addObject: downOn];
        [defaults setObject:new forKey:@"votedCommentsOnArray"];
        [defaults synchronize];
    }
    
    else if (!buttonToggled1 && buttonToggled) {
        [button setTitle:@"▼" forState:UIControlStateNormal];
        buttonToggled1 = YES;
        [upVoteButton setTitle:@"△" forState:UIControlStateNormal];
        buttonToggled = NO;
        k = @"doubledown";
        NSString *emptyString = @"";
        const char *utfString = [emptyString UTF8String];
        dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
        [self startReceive];
        
        
        NSMutableArray * new = [[NSMutableArray alloc] initWithArray: a];
        [new removeObject: upOn];
        [new addObject: downOn];
        [defaults setObject: new forKey:@"votedCommentsOnArray"];
        [defaults synchronize];
    }
    else {
        [button setTitle:@"▽" forState:UIControlStateNormal];
        buttonToggled1 = NO;
        k = @"up";
        NSString *emptyString = @"";
        const char *utfString = [emptyString UTF8String];
        dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
        [self startReceive];
        
        NSMutableArray * new = [[NSMutableArray alloc] initWithArray: a];
        [new removeObject: downOn];
        [defaults setObject: new forKey:@"votedCommentsOnArray"];
        [defaults synchronize];
    }
    
    vote = 0;
}

- (void)info:(UIButton *)button {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    UITableViewCell *cell = (UITableViewCell*)[tableView1 cellForRowAtIndexPath:indexPath];
    
    NSArray* subviews = cell.contentView.subviews;
    for (UIView* subview in subviews) {
        [subview removeFromSuperview];
    }
    cell.textLabel.text = [NSString stringWithFormat: @"Info: \n Votes: %@ \n Posted at: %@",  [[comments objectAtIndex: indexPath.row] votes], [[comments objectAtIndex: indexPath.row] time]];
    [tableView1 deselectRowAtIndexPath:indexPath animated:NO];
    CGRect cellSize = cell.frame;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    back.frame = CGRectMake( 300.f, 5.0f, (400.0f/4)-26, cellSize.size.height-9);
    [back setTitle:@"Back" forState:UIControlStateNormal];
    back.backgroundColor = [UIColor whiteColor];
    back.titleLabel.textColor = [UIColor whiteColor];
    back.layer.borderWidth = 1.0f;
    back.layer.borderColor=[[UIColor blackColor] CGColor];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    back.tag = indexPath.row;
    [cell.contentView addSubview:back];
    
}

- (void)flag:(UIButton *)button {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    NSString *res = [f flag: comments[indexPath.row]];
    if ([res isEqualToString: @"YES"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Post has been flagged"
                                                       message: @"Thanks for helping the community"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        
        [alert setTag:1];
        [alert show];
        
    }
    else if ([res isEqualToString: @"NO"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Post can not be flagged"
                                                       message: @"You have already flagged this post"
                                                      delegate: self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        
        [alert setTag:1];
        [alert show];
    }
    [self refresh];

    
    
}


- (void)back:(UIButton *)button {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    [tableView1 selectRowAtIndexPath:indexPath
                            animated:YES
                      scrollPosition:UITableViewScrollPositionNone];
    [self tableView: tableView1 didSelectRowAtIndexPath:indexPath];
}



- (void) openInfo:(NSIndexPath*) indexPath {
    UITableViewCell *cell = (UITableViewCell*)[tableView1 cellForRowAtIndexPath:indexPath];
    cell.textLabel.text=@"";

    UIButton *upVoteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect cellSize = cell.frame;
    upVoteButton.frame = CGRectMake( 0.0f, 5.0f, 400.0f/4, (cellSize.size.height-9)/2);
    upVoteButton.backgroundColor = [UIColor whiteColor];
    upVoteButton.titleLabel.textColor = [UIColor whiteColor];
    upVoteButton.layer.borderWidth = 1.0f;
    upVoteButton.layer.borderColor=[[UIColor blackColor] CGColor];
    [upVoteButton addTarget:self action:@selector(up:) forControlEvents:UIControlEventTouchUpInside];
    upVoteButton.tag = indexPath.row;
    [upVoteButton setTitle:@"△" forState:UIControlStateNormal];

    UIButton *downVoteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    downVoteButton.frame = CGRectMake( 400.0f/4, 5.0f, 400.0f/4, (cellSize.size.height-9)/2);
    downVoteButton.backgroundColor = [UIColor whiteColor];
    downVoteButton.titleLabel.textColor = [UIColor whiteColor];
    downVoteButton.layer.borderWidth = 1.0f;
    downVoteButton.layer.borderColor=[[UIColor blackColor] CGColor];
    [downVoteButton addTarget:self action:@selector(down:) forControlEvents:UIControlEventTouchUpInside];
    downVoteButton.tag = indexPath.row;
    [downVoteButton setTitle:@"▽" forState:UIControlStateNormal];

    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *a = [defaults objectForKey:@"votedCommentsOnArray"];
    

    if (a != nil) {
        for (int x = 0; x < [a count]; x++) {
            NSMutableArray *ls = [a objectAtIndex: x];
            if ([[[comments objectAtIndex:indexPath.row ]title] isEqualToString: [ls objectAtIndex:0]] && [[[comments objectAtIndex:indexPath.row ]time] isEqualToString: [ls objectAtIndex:1]]) {
                if ([@"up" isEqualToString: [ls objectAtIndex:2]]) {
                    [upVoteButton setTitle:@"▲" forState:UIControlStateNormal];
                    [downVoteButton setTitle:@"▽" forState:UIControlStateNormal];
                }
                if ([@"down" isEqualToString: [ls objectAtIndex:2]]) {
                    [downVoteButton setTitle:@"▼" forState:UIControlStateNormal];
                    [upVoteButton setTitle:@"△" forState:UIControlStateNormal];
                }
            }
        }
    }
    else {
        
    }
    
    [cell.contentView addSubview:upVoteButton];
    [cell.contentView addSubview:downVoteButton];

    

    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake( 400.0f/2, 5.0f, 400.0f/4, (cellSize.size.height-9)/2);
    infoButton.backgroundColor = [UIColor whiteColor];
    infoButton.titleLabel.textColor = [UIColor whiteColor];
    infoButton.layer.borderWidth = 1.0f;
    infoButton.layer.borderColor=[[UIColor blackColor] CGColor];
    [infoButton addTarget:self action:@selector(info:) forControlEvents:UIControlEventTouchUpInside];
    infoButton.tag = indexPath.row;
    [cell.contentView addSubview:infoButton];
    
    UIButton *flag = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    flag.frame = CGRectMake( 300.0f, 5.0f, (400.0f/4)-25, (cellSize.size.height-9)/2);
    [flag setTitle:@"Flag" forState:UIControlStateNormal];
    flag.backgroundColor = [UIColor whiteColor];
    flag.titleLabel.textColor = [UIColor whiteColor];
    flag.layer.borderWidth = 1.0f;
    flag.layer.borderColor=[[UIColor blackColor] CGColor];
    [flag addTarget:self action:@selector(flag:) forControlEvents:UIControlEventTouchUpInside];
    flag.tag = indexPath.row;
    [cell.contentView addSubview:flag];
    
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    back.frame = CGRectMake( 0.0f, (cellSize.size.height)/2, 400.0f - 25, ((cellSize.size.height)/2));
    [back setTitle:@"Back" forState:UIControlStateNormal];
    back.backgroundColor = [UIColor whiteColor];
    back.titleLabel.textColor = [UIColor whiteColor];
    back.layer.borderWidth = 1.0f;
    back.layer.borderColor=[[UIColor blackColor] CGColor];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    back.tag = indexPath.row;
    [cell.contentView addSubview:back];
    
    [tableView1 deselectRowAtIndexPath:indexPath animated:NO];
    cell.tag = 1;
}

- (void) closeInfo:(NSIndexPath*) indexPath {

    UITableViewCell *cell = (UITableViewCell*)[tableView1 cellForRowAtIndexPath:indexPath];

    NSArray* subviews = cell.contentView.subviews;
    for (UIView* subview in subviews) {
        [subview removeFromSuperview];
    }
    cell.textLabel.text = [[comments objectAtIndex: indexPath.row] title];
    [tableView1 deselectRowAtIndexPath:indexPath animated:NO];
    cell.tag = 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *a = [[defaults objectForKey:@"infoOpened"] mutableCopy];
    if (a == nil) {
        a = [[NSMutableArray alloc] init];
        [defaults setObject:a forKey:@"infoOpened"];
        [defaults synchronize];
    }
    
    if (cell.tag == 0) {
        [self openInfo: indexPath];
        NSNumber* n = [NSNumber numberWithInteger: indexPath.row];
        [a addObject: n];
        [defaults setObject: a forKey:@"infoOpened"];
        [defaults synchronize];
    }
    else if (cell.tag == 1) {
        [self closeInfo: indexPath];
        NSNumber* n = [NSNumber numberWithInteger: indexPath.row];
        [a removeObject: n];
        [defaults setObject: a forKey:@"infoOpened"];
        [defaults synchronize];
    }
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
    
    while (self.connection != nil) {
        
    }// don't tap receive twice in a row!
    
    // First get and check the URL.
    if (vote == 1) {
         DefaultGetURLText = [NSString stringWithFormat: @"http://localhost:8080/social/cVotes?type=%@&id=%@", k, [cid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        DefaultGetURLText = [NSString stringWithFormat: @"http://localhost:8080/social/getComments?start=%d&end=%d&type=%@&id=%@", start, end, type, [self.detailItem primaryID]];
    }
    url = [[NetworkManager sharedInstance] smartURLForString: DefaultGetURLText];
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
    
    if ([elementname isEqualToString:@"comment"])
    {
        c = [Comment alloc];
        [parserString appendString:elementname];
        [parserString appendString:@"\n"];
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementname isEqualToString:@"id"])
    {
        [c setPrimaryID: currentNodeContent];
        [parserString appendString:elementname];
        [parserString appendString:@"-->"];
        [parserString appendString:currentNodeContent];
        [parserString appendString:@"\n"];
    }
    if ([elementname isEqualToString:@"title"])
    {
        [c setTitle: currentNodeContent];
        [parserString appendString:elementname];
        [parserString appendString:@"-->"];
        [parserString appendString:currentNodeContent];
        [parserString appendString:@"\n"];
    }
    else if ([elementname isEqualToString:@"author"])
    {
        [c setAuthor: currentNodeContent];
        [parserString appendString:elementname];
        [parserString appendString:@"-->"];
        [parserString appendString:currentNodeContent];
        [parserString appendString:@"\n"];
    }
    else if ([elementname isEqualToString:@"votes"])
    {
        [c setVotes: currentNodeContent];
        [parserString appendString:elementname];
        [parserString appendString:@"-->"];
        [parserString appendString:currentNodeContent];
        [parserString appendString:@"\n"];
    }

    else if ([elementname isEqualToString:@"time"])
    {
        [c setTime: currentNodeContent];
        [parserString appendString:elementname];
        [parserString appendString:@"-->"];
        [parserString appendString:currentNodeContent];
        [parserString appendString:@"\n"];
    }
    
    else if ([elementname isEqualToString:@"comment"])
    {
        
        [parserString appendString:@"\n"];
        
        if (!comments) {
            comments = [[NSMutableArray alloc] init];
        }
        
        NSUInteger x = [comments count];
        [comments insertObject: c atIndex:x];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:x inSection:0];
        [self.tableView1 insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
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


- (void)updateList {
    start = 0;
    end = 25;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *a = [defaults objectForKey:@"infoOpened"];
    a = [[NSMutableArray alloc] init];
    [defaults setObject:a forKey:@"infoOpened"];
    [defaults synchronize];
    [comments removeAllObjects];
    [tableView1 reloadData];
    NSString *emptyString = @"";
    const char *utfString = [emptyString UTF8String];
    dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
    [self startReceive];
}

-(IBAction) refresh {
    [self updateList];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"compose"]) {
        
        ComposeCommentViewController *controller = (ComposeCommentViewController *)[segue destinationViewController];
        
        [controller setDetailItem: self.detailItem];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    
    if ([[segue identifier] isEqualToString:@"compose"]) {
        composeBool = 1;
    }

    
}

@end
