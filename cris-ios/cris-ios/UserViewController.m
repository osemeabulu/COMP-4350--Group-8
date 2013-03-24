//
//  UserViewController.m
//  cris-ios
//
//  Created by Noel Ganotisi on 2013-03-21.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "UserViewController.h"
#import "AppDelegate.h"
#import "LoginSession.h"

@interface UserViewController ()

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *createConn;

- (void)postJSONObjects:(NSData *)jsonRequest
             connection:(NSURLConnection *)connection
                    url:(NSURL *)url;
@end

@implementation UserViewController

@synthesize responseData;
@synthesize userField;
@synthesize passwordField;

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
    /*AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSString *urlString = [NSString stringWithFormat:@"%@users/_check_session", appDel.baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];*/
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    NSString *user = [res objectForKey:@"session"];
    
    UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Login Failed. Try again" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Login Success" message:@"You are now logged in" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    //[alert addButtonWithTitle:@"OK"];
    NSLog (@"%@", user);

    if(![user isEqualToString:@"not logged in"]){
        LoginSession *session = [LoginSession sharedInstance];
        [session setUser:user];
        
        [success show];
    } else{
        [fail show];
    }
}

- (IBAction)loginButton:(id)sender {
    NSError* error;
    NSString *username = [NSString stringWithString:self.userField.text];
    NSString *password = [NSString stringWithString:self.passwordField.text];
    
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setValue:username forKey:@"name"];
    [info setValue:password forKey:@"pass"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Required" message:@"Please enter a valid username and password" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    
    if([userField.text length] == 0 || [passwordField.text length] == 0){
        [alert show];
    }
    else{
    
        NSData *jsonObj = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
        
        NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:5000//users/_check_session"];
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        //NSString *urlString = [NSString stringWithFormat:@"%@users/_check_session", appDel.baseURL];
        //NSURL *url = [NSURL URLWithString:urlString];
        [self postJSONObjects:jsonObj connection:self.createConn url:url];
        
        //[self.loginButton setEnabled:NO];
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
