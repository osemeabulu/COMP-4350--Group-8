//
//  ReviewViewController.m
//  cris-ios
//
//  Created by Rory Finnegan on 2013-03-17.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "ReviewViewController.h"
#import "AppDelegate.h"

@interface ReviewViewController ()
@property (nonatomic, strong) NSMutableData *createResponseData;
@property (nonatomic, strong) NSMutableData *voteResponseData;
@property (nonatomic, strong) NSURLConnection *createConn;
@property (nonatomic, strong) NSURLConnection *voteConn;

- (void)postJSONObjects:(NSData *)jsonRequest
                       connection:(NSURLConnection *)connection
                       url:(NSURL *)url;

@end

@implementation ReviewViewController

@synthesize createResponseData;
@synthesize voteResponseData;
@synthesize createConn;
@synthesize voteConn;
@synthesize courseLabel;
@synthesize userLabel;
@synthesize scorePicker;
@synthesize descText;
@synthesize createButton;
@synthesize likeButton;
@synthesize dislikeButton;
@synthesize likeLabel;
@synthesize dislikeLabel;


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
    [super viewDidLoad];
    self.courseLabel.text = self.review.cid;
    
    NSRange textRange = [self.review.username rangeOfString:@"null"];
    if (textRange.location != NSNotFound)
    {
        self.userLabel.text = [NSString stringWithFormat:@"N/A"];
    }
    
    else
    {
        self.userLabel.text = self.review.username;
    }
    self.createResponseData = [NSMutableData data];
    self.voteResponseData = [NSMutableData data];
    self.scorePicker.dataSource = self;
    self.scorePicker.delegate = self;
    [self.scorePicker reloadAllComponents];
    [self.scorePicker selectRow:self.review.rscr.intValue - 1 inComponent:0 animated:YES];
    self.descText.delegate = self;
    self.descText.text = self.review.rdesc;
    self.likeLabel.text = self.review.upvote;
    self.dislikeLabel.text = self.review.downvote;
    self.createConn = nil;
    self.voteConn = nil;
    
    if (self.cdvc == nil)
    {
        //should check if we are the user that wrote the review when
        //users feature is completed
        [self.createButton setHidden:YES];
        [self.createButton setEnabled:NO];
        [self.descText setEditable:NO];
        [self.scorePicker setUserInteractionEnabled:NO];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)imageForRating:(int)rating
{
	switch (rating)
	{
		case 1: return [UIImage imageNamed:@"1StarSmall.png"];
		case 2: return [UIImage imageNamed:@"2StarsSmall.png"];
		case 3: return [UIImage imageNamed:@"3StarsSmall.png"];
		case 4: return [UIImage imageNamed:@"4StarsSmall.png"];
		case 5: return [UIImage imageNamed:@"5StarsSmall.png"];
	}
	return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIImageView *result = [[UIImageView alloc] initWithImage: [self imageForRating: row + 1]];
    return result;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    [self.voteResponseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.voteResponseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Received JSON votes! Received %d bytes of data", [self.voteResponseData length]);
    
    if (connection != nil && connection == voteConn)
    {
        //convert to JSON
        NSError *myError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.voteResponseData options:NSJSONReadingMutableLeaves error:&myError];

        NSString *score = [NSString stringWithFormat:@"%@",[json objectForKey:@"score"]];
        NSString *upvote = [NSString stringWithFormat:@"%@",[json objectForKey:@"up"]];
        NSString *downvote = [NSString stringWithFormat:@"%@",[json objectForKey:@"down"]];
        NSString *i = [NSString stringWithFormat:@"%@",[json objectForKey:@"i"]];

        self.likeLabel.text = upvote;
        self.dislikeLabel.text = downvote;
    }
    
    else if (connection != nil && connection == createConn)
    {
        //perform post request review creation processing
        if (self.cdvc != nil)
        {
            NSError *err = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.createResponseData options:NSJSONReadingMutableLeaves error:&err];
            
            //create a new review locally
            self.review = [[Review alloc] initWithCid: [NSString stringWithFormat:@"%@", [json objectForKey:@"cid"]] username: [NSString stringWithFormat:@"%@", [json objectForKey:@"username"]] rdesc: [NSString stringWithFormat:@"%@", [json objectForKey:@"rdesc"]] rscr: [NSString stringWithFormat:@"%@", [json objectForKey:@"rscr"]] upvote: [NSString stringWithFormat:@"%@", [json objectForKey:@"upvote"]] downvote: [NSString stringWithFormat:@"%@", [json objectForKey:@"downvote"]] rvote: [NSString stringWithFormat:@"%@", [json objectForKey:@"rvote"]] pk: [NSString stringWithFormat:@"%@", [json objectForKey:@"id"]]];
            
            //add the review to the CoureDetailViewController
            [self.cdvc.reviews addObject:self.review];
            
            //Then reload the reviewLists data to complete update on CourseDetailViewController
            //[self.cdvc.reviewList reloadData];
        }
    }
    
}


- (IBAction)like:(id)sender {
    NSError* error;
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt: self.review.index.intValue ], @"index", [NSNumber numberWithInt: self.review.upvote.intValue], @"upvote", [NSNull null], @"downvote", [NSNumber numberWithInt: self.review.pk.intValue], @"key",nil];
    
    NSData* jsonObj = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    
    //NSURL *url = [NSURL URLWithString:@"http://0.0.0.0:5000/reviews/_vote"];
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSString *urlString = [NSString stringWithFormat:@"%@reviews/_vote", appDel.baseURL];
    NSURL *url = [NSURL URLWithString:urlString];
    //NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    [self postJSONObjects:jsonObj connection:self.voteConn url:url];
    
    [self.likeButton setEnabled:NO];
    
}

- (IBAction)dislike:(id)sender {
    NSError* error;
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt: self.review.index.intValue ], @"index", [NSNull null], @"upvote", [NSNumber numberWithInt: self.review.downvote.intValue], @"downvote", [NSNumber numberWithInt: self.review.pk.intValue], @"key",nil];
    
    NSData* jsonObj = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    
    //NSURL *url = [NSURL URLWithString:@"http://0.0.0.0:5000/reviews/_vote"];
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSString *urlString = [NSString stringWithFormat:@"%@reviews/_vote", appDel.baseURL];
    NSURL *url = [NSURL URLWithString:urlString];
    [self postJSONObjects:jsonObj connection:self.voteConn url:url];
    
    [self.dislikeButton setEnabled:NO];

}

- (IBAction)create:(id)sender {
    if (self.cdvc != nil)
    {
        //perform creating code
        NSError* error;
    
        NSString *cid = [NSString stringWithString:self.review.cid];
        NSString *desc = [NSString stringWithString:self.descText.text];
        NSNumber *scr = [NSNumber numberWithInt:[self.scorePicker selectedRowInComponent:0] + 1];
    
        NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
                                     [info setValue:cid forKey:@"cid"];
                                     [info setValue:scr forKey:@"rscr"];
                                     [info setValue:desc forKey:@"rdesc"];
                                     [info setValue:[NSNull null] forKey:@"rvote"];
                                     [info setValue:[NSNull null] forKey:@"upvote"];
                                     [info setValue:[NSNull null] forKey:@"downvote"];
    
        NSData *jsonObj = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    
        //NSURL *url = [NSURL URLWithString:@"http://0.0.0.0:5000/reviews/_submit_review"];
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        NSString *urlString = [NSString stringWithFormat:@"%@reviews/_submit_review", appDel.baseURL];
        NSURL *url = [NSURL URLWithString:urlString];
        [self postJSONObjects:jsonObj connection:self.createConn url:url];
    
        [self.createButton setEnabled:NO];
    }
}

- (void)postJSONObjects:(NSData *)jsonRequest connection:(NSURLConnection *)connection url:(NSURL *)url
{
    //NSURL *url = [NSURL URLWithString:@"http://0.0.0.0:5000/reviews/_vote"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    //NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonRequest];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
