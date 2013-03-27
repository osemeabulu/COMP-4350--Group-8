//
//  NewPostViewController.m
//  cris-ios
//
//  Created by Scott Hofer on 2013-03-20.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "AppDelegate.h"
#import "NewPostViewController.h"

@interface NewPostViewController ()

@property (nonatomic, strong) NSURLConnection *createConn;
@property (nonatomic, strong) NSMutableData *responseData;

- (void)postJSONObjects:(NSData *)jsonRequest
             connection:(NSURLConnection *)connection
                    url:(NSURL *)url;

@end

@implementation NewPostViewController

@synthesize responseData;
@synthesize createConn;
@synthesize postText;
@synthesize navController;

- (IBAction)createPost:(id)sender {
    //perform creating code
    NSError* error;
    
    NSString *msg = [NSString stringWithString:self.postText.text];
    
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setValue:msg forKey:@"msg"];
    
    NSData *jsonObj = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSString *urlString = [NSString stringWithFormat:@"%@posts/_submit_post", appDel.baseURL];
    NSURL *url = [NSURL URLWithString:urlString];
    [self postJSONObjects:jsonObj connection:self.createConn url:url];
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
    self.responseData = [NSMutableData data];
    self.createConn = nil;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data", [self.responseData length]);
    
    //convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    BOOL result = [[res objectForKey:@"posted"] boolValue];
    UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Post Failure" message:@"Post Failed. Try again" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    
    UIAlertView *loginfail = [[UIAlertView alloc] initWithTitle:@"Login Required" message:@"Post Failed. Please Login" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Post Success" message:@"Post was successfully created" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    
    if(result){
        [success show];
        self.navController = self.navigationController;
        //[[self retain] autorelease];
        [navController popViewControllerAnimated:YES];
    } else {
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        if ([appDel.curr_user isEqualToString:@"N/A"]) {
            [loginfail show];
        }
        else {
            [fail show];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
