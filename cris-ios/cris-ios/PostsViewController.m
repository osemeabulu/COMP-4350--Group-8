//
//  PostsViewController.m
//  cris-ios
//
//  Created by Scott Hofer on 2013-03-20.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "AppDelegate.h"
#import "PostsViewController.h"

@interface PostsViewController ()

@property (nonatomic, strong) NSMutableArray *myPosts;
@property (nonatomic, strong) NSMutableArray *postTime;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation PostsViewController

@synthesize postsTableView;
@synthesize myPosts;
@synthesize responseData = _responseData;
@synthesize postTime;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"viewdidload");
    //[self switchcontrol:(id)self];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    if ([appDel.curr_user isEqualToString:@"N/A"]) {
        [control setEnabled:NO];
        [self switchcontrol:(id)self];
    }
    else {
        [control setEnabled:YES];
        control.selectedSegmentIndex = 0;
        [self switchcontrol:(id)self];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return myPosts.count; //number of cells in the table
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MainCell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[myPosts objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [postTime objectAtIndex:indexPath.row]];
    cell.textLabel.textColor = [UIColor blueColor];
    
    return cell;
}

-(IBAction)switchcontrol:(id)sender {
    self.myPosts = [NSMutableArray array];
    self.postTime = [NSMutableArray array];
    self.responseData = [NSMutableData data];
    if (control.selectedSegmentIndex == 0) {
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        NSString *urlString = [NSString stringWithFormat:@"%@posts/_query", appDel.baseURL];
        NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
        //NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://cris-release-env-przrapykha.elasticbeanstalk.com/instructors/_query"]];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];

    }
    if (control.selectedSegmentIndex == 1) {
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        NSString *urlString = [NSString stringWithFormat:@"%@posts/_query_following", appDel.baseURL];
        NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
        //NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://cris-release-env-przrapykha.elasticbeanstalk.com/instructors/_query"]];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    if (control.selectedSegmentIndex == 2) {
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        NSString *urlString = [NSString stringWithFormat:@"%@posts/_query_followers", appDel.baseURL];
        NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
        //NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://cris-release-env-przrapykha.elasticbeanstalk.com/instructors/_query"]];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data", [self.responseData length]);
    
    //convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    NSArray *jsonPosts = [res objectForKey:@"posts"];
    
    // get each instructors attributes and place them into the array of strings
    for (NSDictionary *result in jsonPosts)
    {
        NSString *post = [NSString stringWithFormat:@"%@ - %@", [result objectForKey:@"owner"],  [result objectForKey:@"message"]];
        NSString *thisTime = [NSString stringWithFormat:@"%@", [result objectForKey:@"time"]];
        NSLog(thisTime);
        
        [self.myPosts addObject:post];
        [self.postTime addObject:thisTime];
    }

    [self.postsTableView reloadData];
}


@end
