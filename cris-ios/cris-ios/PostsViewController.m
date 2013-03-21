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
@property (nonatomic, strong) NSMutableArray *followers;
@property (nonatomic, strong) NSMutableArray *following;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation PostsViewController

@synthesize postsTableView;
@synthesize myPosts;
@synthesize responseData = _responseData;



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
    [self switchcontrol:(id)self];
    [super viewDidLoad];
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",[myPosts objectAtIndex:indexPath.row],@"hello"];
    cell.detailTextLabel.text = @"time";
    cell.textLabel.textColor = [UIColor blueColor];
    
    return cell;
}

-(IBAction)switchcontrol:(id)sender {
    self.myPosts = [NSMutableArray array];
    self.responseData = [NSMutableData data];
    if (control.selectedSegmentIndex == 0) {
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        NSString *urlString = [NSString stringWithFormat:@"%@instructors/_query", appDel.baseURL];
        NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
        //NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://cris-release-env-przrapykha.elasticbeanstalk.com/instructors/_query"]];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];

    }
    if (control.selectedSegmentIndex == 1) {
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        NSString *urlString = [NSString stringWithFormat:@"%@instructors/_query", appDel.baseURL];
        NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
        //NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://cris-release-env-przrapykha.elasticbeanstalk.com/instructors/_query"]];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    if (control.selectedSegmentIndex == 2) {
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        NSString *urlString = [NSString stringWithFormat:@"%@instructors/_query", appDel.baseURL];
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
    
    NSArray *jsonPosts = [res objectForKey:@"instructors"];
    
    // get each instructors attributes and place them into the array of strings
    for (NSDictionary *result in jsonPosts)
    {
        NSString *post = [NSString stringWithFormat:@"%@", [result objectForKey:@"pname"]];
        
        [self.myPosts addObject:post];
    }
    
    [self.postsTableView reloadData];
}


@end
