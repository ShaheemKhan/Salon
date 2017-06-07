//
//  MasterViewController.m
//  project
//
//  Created by Shaheem Khan on 2014-11-12.
//  Copyright (c) 2014 Shaheem Khan. All rights reserved.
//



#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SimpleTableCell.h"
#import "NetworkManager.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

@synthesize connection;
@synthesize parserString;
@synthesize currentNodeContent;
@synthesize p;
@synthesize f;
@synthesize sortByLabel, refresh;
NSXMLParser     *parser;
int composeBool;
int start;
int end;
NSString *type;
static NSString * DefaultGetURLText = @"http://localhost:8080/social/getPosts?start=0&end=25&type=n";
@synthesize searchBar;
int searching;

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}
- (void)viewDidAppear:(BOOL)animated {
    if (composeBool == 1)
        [self updateList];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.navigationController.toolbarHidden = NO;
    NSMutableArray *items = [NSMutableArray array];
    searchResults = [[NSMutableArray alloc] init];

    self.navigationController.toolbar.items = items;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    NSString *emptyString = @"";
    const char *utfString = [emptyString UTF8String];
    dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
    [self startReceive];
    composeBool = 0;
    f = [[Flag alloc] init];
    end = 25;
    start = 0;
    type = @"n";
    
    searching = 0;
}



- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView setContentOffset:CGPointMake(0, 44)];
}

-(IBAction) search:(id) sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.tableView.contentOffset = CGPointMake(0, 0);
    } completion:nil];
    [searchBar becomeFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1 {
    NSLog(@"%@", [searchBar1 text]);
    DefaultGetURLText = [NSString stringWithFormat: @"http://localhost:8080/social/search?query=%@&start=0&end=25", [[[searchBar1 text] lowercaseString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [searchResults removeAllObjects];
    [self.searchDisplayController.searchResultsTableView reloadData];
    searching = 1;
    NSString *emptyString = @"";
    const char *utfString = [emptyString UTF8String];
    dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
    [self startReceive];
}


- (void)searchDisplayControllerDidEndSearch:(UISearchController *)controller {
    searching = 0;
    self.tableView.contentOffset = CGPointMake(0, -20);

}
- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate
{
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 50;
    if(y > h + reload_distance) {
        start += 25;
        end += 25;
        DefaultGetURLText = [NSString stringWithFormat: @"http://localhost:8080/social/getPosts?start=%d&end=%d&type=%@", start, end, type];
        [self addNew];
    }
}

- (void) addNew {
    NSString *emptyString = @"";
    const char *utfString = [emptyString UTF8String];
    dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
    [self startReceive];
}


- (void)updateList {
    start = 0;
    end = 25;
     DefaultGetURLText = [NSString stringWithFormat: @"http://localhost:8080/social/getPosts?start=0&end=25&type=%@", type];
    [self.objects removeAllObjects];
    [self.tableView reloadData];
    NSString *emptyString = @"";
    const char *utfString = [emptyString UTF8String];
    dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
    [self startReceive];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) refresh {
    [self updateList];
}

-(IBAction) sort {
    if ([sortByLabel.title isEqualToString: @"Newest"]) {
        sortByLabel.title = @"Highest Voted";
        type = @"n";
        DefaultGetURLText = [NSString stringWithFormat: @"http://localhost:8080/social/getPosts?start=%d&end=%d&type=%@", start, end, type];
        [self updateList];
    }
    else if ([sortByLabel.title isEqualToString: @"Highest Voted"]) {
        sortByLabel.title =  @"Newest";
        type = @"v";
        DefaultGetURLText = [NSString stringWithFormat: @"http://localhost:8080/social/getPosts?start=%d&end=%d&type=%@", start, end, type];
        [self updateList];
    }
}



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
       // NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        searching = 0;
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem: sender];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    
    if ([[segue identifier] isEqualToString:@"compose"]) {
        composeBool = 1;
    }

}
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else {
        return self.objects.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SimpleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SimpleTableCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    
    cell.contentView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    cell.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    cell.contentMode = UIViewContentModeScaleAspectFill;
    cell.indentationLevel = 0;
    cell.shouldIndentWhileEditing = NO;
    
    NSMutableArray *m;
    if (searching == 1) {
        m = searchResults;
    }
    else {
        m = self.objects;
    }
  //  NSLog(@"gfg %@ fds %@", [m count], [indexPath.row]);
    cell.titleLabel.text = [m[indexPath.row] title];
    cell.timeLabel.text = [m[indexPath.row] time];
    cell.votesLabel.text = [m[indexPath.row] votes];
    cell.commentsLabel.text = [NSString stringWithFormat:@"%@%@", [m[indexPath.row] comments], @" comments"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *a = [defaults objectForKey:@"votedOnArray"];
    if (a != nil) {
        for (int x = 0; x < [a count]; x++) {
            NSMutableArray *k = [a objectAtIndex: x];
            if ([cell.titleLabel.text isEqualToString: [k objectAtIndex:0]] && [cell.timeLabel.text isEqualToString: [k objectAtIndex:1]]) {
                if ([@"up" isEqualToString: [k objectAtIndex:2]]) {
                    [cell.agree setTitle:@"▲" forState:UIControlStateNormal];
                    [cell.disagree setTitle:@"▽" forState:UIControlStateNormal];
                    return cell;
                }
                if ([@"down" isEqualToString: [k objectAtIndex:2]]) {
                    [cell.disagree setTitle:@"▼" forState:UIControlStateNormal];
                    [cell.agree setTitle:@"△" forState:UIControlStateNormal];
                    return cell;
                }
            }
        }
    }
    
    
    [cell.agree setTitle:@"△" forState:UIControlStateNormal];
    [cell.disagree setTitle:@"▽" forState:UIControlStateNormal];
    cell.pid =[m[indexPath.row] primaryID];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *m;
    if (searching == 1) {
        m = searchResults;
    }
    else {
        m = self.objects;
    }

    [self performSegueWithIdentifier:@"showDetail"sender:m[indexPath.row]];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
    NSMutableArray *m;
    if (searching == 1) {
        m = searchResults;
    }
    else {
        m = self.objects;
    }

    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *res = [f flag: m[indexPath.row]];
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
    }
    
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Flag";
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
    
    assert (self.connection == nil);       // don't tap receive twice in a row!
    
    // First get and check the URL.
    
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


//http://www.theappcodeblog.com/2011/05/09/parsing-xml-in-an-iphone-app-tutorial/
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if ([elementname isEqualToString:@"post"])
    {
        p = [Post alloc];
        [parserString appendString:elementname];
        [parserString appendString:@"\n"];
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementname isEqualToString:@"id"])
    {
        [p setPrimaryID: currentNodeContent];
        [parserString appendString:elementname];
        [parserString appendString:@"-->"];
        [parserString appendString:currentNodeContent];
        [parserString appendString:@"\n"];
    }
    if ([elementname isEqualToString:@"title"])
    {
        [p setTitle: currentNodeContent];
        [parserString appendString:elementname];
        [parserString appendString:@"-->"];
        [parserString appendString:currentNodeContent];
        [parserString appendString:@"\n"];
    }
    else if ([elementname isEqualToString:@"author"])
    {
        [p setAuthor: currentNodeContent];
        [parserString appendString:elementname];
        [parserString appendString:@"-->"];
        [parserString appendString:currentNodeContent];
        [parserString appendString:@"\n"];
    }
    else if ([elementname isEqualToString:@"votes"])
    {
        [p setVotes: currentNodeContent];
        [parserString appendString:elementname];
        [parserString appendString:@"-->"];
        [parserString appendString:currentNodeContent];
        [parserString appendString:@"\n"];
    }
    else if ([elementname isEqualToString:@"comments"])
    {
        [p setComments: currentNodeContent];
        [parserString appendString:elementname];
        [parserString appendString:@"-->"];
        [parserString appendString:currentNodeContent];
        [parserString appendString:@"\n"];
    }
    else if ([elementname isEqualToString:@"time"])
    {
        [p setTime: currentNodeContent];
        [parserString appendString:elementname];
        [parserString appendString:@"-->"];
        [parserString appendString:currentNodeContent];
        [parserString appendString:@"\n"];
    }
    else if ([elementname isEqualToString:@"post"])
    {
        [parserString appendString:@"\n"];
        NSLog(@"YESSSSSSD");
        if (!self.objects) {
            self.objects = [[NSMutableArray alloc] init];
        }
        
        NSUInteger x = [self.objects count];
        NSUInteger y = [searchResults count];

        if (searching == 1) {
            [searchResults insertObject: p atIndex:y];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:y inSection:0];
            [self.searchDisplayController.searchResultsTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else {
            [self.objects insertObject: p atIndex:x];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:x inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
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

@end
