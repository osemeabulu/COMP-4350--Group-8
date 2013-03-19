//
//  ReviewViewController.m
//  cris-ios
//
//  Created by Finn Wake on 2013-03-17.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "ReviewViewController.h"

@interface ReviewViewController ()
@property (nonatomic, strong) NSMutableData *responseData;
- (void)postJSONObjects:(NSData *)jsonRequest;
@end

@implementation ReviewViewController

@synthesize responseData;
@synthesize courseLabel;
@synthesize userLabel;
@synthesize scorePicker;
@synthesize descText;
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
    self.responseData = [NSMutableData data];
    self.scorePicker.dataSource = self;
    self.scorePicker.delegate = self;
    [self.scorePicker reloadAllComponents];
    [self.scorePicker selectRow:self.review.rscr.intValue - 1 inComponent:0 animated:YES];
    self.descText.delegate = self;
    self.descText.text = self.review.rdesc;
    self.likeLabel.text = self.review.upvote;
    self.dislikeLabel.text = self.review.downvote;
        
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
    NSLog(@"Received JSON votes! Received %d bytes of data", [self.responseData length]);
    
    //convert to JSON
    NSError *myError = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];

    NSString *score = [NSString stringWithFormat:@"%@",[json objectForKey:@"score"]];
    NSString *upvote = [NSString stringWithFormat:@"%@",[json objectForKey:@"up"]];
    NSString *downvote = [NSString stringWithFormat:@"%@",[json objectForKey:@"down"]];
    NSString *i = [NSString stringWithFormat:@"%@",[json objectForKey:@"i"]];

    self.likeLabel.text = upvote;
    self.dislikeLabel.text = downvote;
    
}


- (IBAction)like:(id)sender {
    NSError* error;
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt: self.review.index.intValue ], @"index", [NSNumber numberWithInt: self.review.upvote.intValue], @"upvote", [NSNull null], @"downvote", [NSNumber numberWithInt: self.review.pk.intValue], @"key",nil];
    
    NSData* jsonObj = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    
    [self postJSONObjects:jsonObj];
    
    [self.likeButton setEnabled:NO];
    
}

- (IBAction)dislike:(id)sender {
    NSError* error;
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt: self.review.index.intValue ], @"index", [NSNull null], @"upvote", [NSNumber numberWithInt: self.review.downvote.intValue], @"downvote", [NSNumber numberWithInt: self.review.pk.intValue], @"key",nil];
    
    NSData* jsonObj = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    [self postJSONObjects:jsonObj];
    
    [self.dislikeButton setEnabled:NO];

}

- (void)postJSONObjects:(NSData *)jsonRequest{
    NSURL *url = [NSURL URLWithString:@"http://0.0.0.0:5000/reviews/_vote"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    //NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonRequest];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

@end
