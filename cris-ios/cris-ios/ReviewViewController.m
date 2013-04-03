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
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *createConn;
@property (nonatomic, strong) NSURLConnection *voteConn;
@property (nonatomic, strong) NSURLConnection *checkfollowerConn;
@property (nonatomic, strong) NSURLConnection *followConn;
@property (nonatomic, strong) NSURLConnection *unfollowConn;

- (NSURLConnection* )postJSONObjects:(NSData *)jsonRequest
                    url:(NSURL *)url;

@end

@implementation ReviewViewController


@synthesize navController;
@synthesize responseData;
@synthesize createConn;
@synthesize voteConn;
@synthesize checkfollowerConn;
@synthesize followConn;
@synthesize unfollowConn;
@synthesize courseLabel;
@synthesize userLabel;
@synthesize scorePicker;
@synthesize descText;
@synthesize createButton;
@synthesize likeButton;
@synthesize dislikeButton;
@synthesize followButton;
@synthesize unfollowButton;
@synthesize likeLabel;
@synthesize dislikeLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self viewDidLoad];
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
    self.createConn = nil;
    self.voteConn = nil;
    self.checkfollowerConn = nil;
    
    
    
    if (self.cdvc == nil)
    {
        //should check if we are the user that wrote the review when
        //users feature is completed
        [self.createButton setHidden:YES];
        [self.createButton setEnabled:NO];
        [self.descText setEditable:NO];
        [self.scorePicker setUserInteractionEnabled:NO];
        [self.saveChanges setHidden:YES];
        [self.saveChanges setEnabled:NO];
        [self.deleteButton setHidden:YES];
        [self.deleteButton setEnabled:NO];
        
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        
        //if user is not logged in hide the follow/unfollow buttons
        if([appDel.curr_user isEqualToString:@"N/A"] || [self.userLabel.text isEqualToString:@"N/A"])
        {
            [self.followButton setHidden:YES];
            [self.unfollowButton setHidden: YES];
            [self.followButton setEnabled:NO];
            [self.unfollowButton setEnabled:NO];
        }
        else if (![appDel.curr_user isEqualToString:self.review.username])
        {
            //AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
            NSString *username = appDel.curr_user;
            NSString *followed = self.review.username;
            
            NSString *urlString = [NSString stringWithFormat:@"%@users/_check_follower?key=%@", appDel.baseURL, followed];
            NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
            self.checkfollowerConn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        else
        {
            //set description and score picker available for editing
            [self.descText setEditable:YES];
            [self.scorePicker setUserInteractionEnabled:YES];
            
            [self.saveChanges setHidden:NO];
            [self.saveChanges setEnabled:YES];
            [self.deleteButton setHidden:NO];
            [self.deleteButton setEnabled:YES];
            
            //hide follow buttons so user doesn't follow themselves
            [self.followButton setHidden:YES];
            [self.unfollowButton setHidden: YES];
            [self.followButton setEnabled:NO];
            [self.unfollowButton setEnabled:NO];
            
        }
    }
    else
    {
        //User is creating review, hide edit, delete and follow buttons
        [self.saveChanges setHidden:YES];
        [self.saveChanges setEnabled:NO];
        [self.deleteButton setHidden:YES];
        [self.deleteButton setEnabled:NO];
        [self.followButton setHidden:YES];
        [self.unfollowButton setHidden: YES];
        [self.followButton setEnabled:NO];
        [self.unfollowButton setEnabled:NO];
        
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
    NSError *myError = nil;
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Received JSON votes! Received %d bytes of data", [self.responseData length]);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog([NSString stringWithFormat:@"Response: %@", json]);
    
    
    if (connection != nil && connection == voteConn)
    {
        //convert to JSON
        NSError *myError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];

        NSString *upvote = [NSString stringWithFormat:@"%@",[json objectForKey:@"up"]];
        NSString *downvote = [NSString stringWithFormat:@"%@",[json objectForKey:@"down"]];
        
        self.likeLabel.text = upvote;
        self.dislikeLabel.text = downvote;
        
        
    }
    else if(connection != nil && connection == checkfollowerConn){
        NSError *myError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
        
            
        NSArray *jsonFollowed = [json objectForKey:@"followed"];
        NSDictionary *dict = [jsonFollowed objectAtIndex:0];
        
        NSString *count = [dict objectForKey:@"followed"];
        
        if(count.intValue > 0)
        {
            [followButton setHidden: YES];
            [followButton setEnabled:NO];
            
        }
        else{
            [unfollowButton setHidden: YES];
            [unfollowButton setEnabled:NO];
        }

    }
    else if(connection != nil && connection == followConn){
        NSError *myError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
        
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You are now following this user." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"You cannot follow N/A." delegate:self
            cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        BOOL jsonFollowed = [[json objectForKey:@"followed"] boolValue];
        
        if(jsonFollowed)
        {
            [success show];
            [followButton setHidden: YES];
            [followButton setEnabled:NO];
            [unfollowButton setHidden:NO];
            [unfollowButton setEnabled:YES];
        }
        else{
            [fail show];
        }
    }
    else if(connection != nil && connection == unfollowConn){
        NSError *myError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
        
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You are not following this user." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"You cannot unfollow this user" delegate:self
                                             cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        BOOL jsonUnfollow = [[json objectForKey:@"unfollowed"] boolValue];
        
        if(jsonUnfollow)
        {
            [success show];
            [unfollowButton setHidden: YES];
            [unfollowButton setEnabled:NO];
            [followButton setHidden:NO];
            [followButton setEnabled:YES];
        }
        else{
            [fail show];
        }

    }
    

}


- (IBAction)like:(id)sender {
    NSError* error;
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt: self.review.index.intValue ], @"index", [NSNumber numberWithInt: self.review.upvote.intValue], @"upvote", [NSNull null], @"downvote", [NSNumber numberWithInt: self.review.pk.intValue], @"key",nil];
    
    NSData* jsonObj = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    

    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSString *urlString = [NSString stringWithFormat:@"%@reviews/_vote", appDel.baseURL];
    NSURL *url = [NSURL URLWithString:urlString];

    self.voteConn = [self postJSONObjects:jsonObj url:url];
    [self.likeButton setEnabled:NO];
    
    
}

- (IBAction)dislike:(id)sender {
    NSError* error;
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt: self.review.index.intValue ], @"index", [NSNull null], @"upvote", [NSNumber numberWithInt: self.review.downvote.intValue], @"downvote", [NSNumber numberWithInt: self.review.pk.intValue], @"key",nil];
    
    NSData* jsonObj = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSString *urlString = [NSString stringWithFormat:@"%@reviews/_vote", appDel.baseURL];
    NSURL *url = [NSURL URLWithString:urlString];
    
    self.voteConn = [self postJSONObjects:jsonObj url:url];
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
                                     [info setValue:[NSNumber numberWithInt:(0)] forKey:@"rvote"];
                                     [info setValue:[NSNumber numberWithInt:(0)] forKey:@"upvote"];
                                     [info setValue:[NSNumber numberWithInt:(0)] forKey:@"downvote"];
    
        NSData *jsonObj = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        NSString *urlString = [NSString stringWithFormat:@"%@reviews/_submit_review", appDel.baseURL];
        NSURL *url = [NSURL URLWithString:urlString];

        //[self postJSONObjects:jsonObj connection:self.createConn url:url];
        self.createConn = [self postJSONObjects:jsonObj url:url];

        [self.createButton setEnabled:NO];
        self.navController = self.navigationController;
        //[[self retain] autorelease];
        [navController popViewControllerAnimated:YES];


    }
}

- (IBAction)edit:(id)sender
{
    //perform deletion code
    NSError* error;
    
    NSString *pk = [NSString stringWithString:self.review.pk];
    NSString *desc = [NSString stringWithString:self.descText.text];
    NSNumber *scr = [NSNumber numberWithInt:[self.scorePicker selectedRowInComponent:0] + 1];
    
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
                                [info setValue:pk forKey:@"id"];
                                [info setValue:scr forKey:@"rscr"];
                                [info setValue:desc forKey:@"rdesc"];
                                [info setValue:[NSNumber numberWithInt:(0)] forKey:@"rvote"];
                                [info setValue:[NSNumber numberWithInt:(0)] forKey:@"upvote"];
                                [info setValue:[NSNumber numberWithInt:(0)] forKey:@"downvote"];
    
    
    NSData *jsonObj = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSString *urlString = [NSString stringWithFormat:@"%@reviews/_update_review", appDel.baseURL];
    NSURL *url = [NSURL URLWithString:urlString];
    
    self.createConn = [self postJSONObjects:jsonObj url:url];
    [self.saveChanges setEnabled:NO];
    self.navController = self.navigationController;
    [navController popViewControllerAnimated:YES];
    
}

- (IBAction)del:(id)sender
{
    //perform deletion code
    NSError* error;
    
    NSString *pk = [NSString stringWithString:self.review.pk];
    
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
                                [info setValue:pk forKey:@"id"];
    
    NSData *jsonObj = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSString *urlString = [NSString stringWithFormat:@"%@reviews/_delete_review", appDel.baseURL];
    NSURL *url = [NSURL URLWithString:urlString];
    
    self.createConn = [self postJSONObjects:jsonObj url:url];
    [self.deleteButton setEnabled:NO];
    self.navController = self.navigationController;
    [navController popViewControllerAnimated:YES];
}


- (NSURLConnection *)postJSONObjects:(NSData *)jsonRequest url:(NSURL *)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonRequest];
    
    return [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (IBAction)follow:(id)sender {
    NSError* error;
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSString *followed = [NSString stringWithString:self.review.username];
    NSString *urlString = [NSString stringWithFormat:@"%@users/_follow_user?key=%@", appDel.baseURL, followed];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    
    self.followConn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (IBAction)unfollow:(id)sender {
    NSError* error;
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSString *followed = [NSString stringWithString:self.review.username];
    NSString *urlString = [NSString stringWithFormat:@"%@users/_unfollow_user?key=%@", appDel.baseURL, followed];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    
    self.unfollowConn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
@end
