//
//  UserTests.m
//  cris-ios
//
//  Created by Rory Finnegan on 2013-03-25.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "UserTests.h"

@implementation UserTests
{
    //server address
    NSString* serverAddress;
    
    //response data from requests
    NSMutableData *responseData;
    
    //connections
    NSURLConnection *connection;
    
    //connections finished
    BOOL done;
}

- (void)setUp
{
    [super setUp];
    
    responseData = [NSMutableData data];
    serverAddress = @"http://grp8-env-t6urakw4up.elasticbeanstalk.com";
    done = NO;
}


- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    done = YES;
}

- (void)testUserQueryGood
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *queryString = @"test";
    NSString *connectionAddress = @"users/_query_user";
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?key=%@", serverAddress, connectionAddress, queryString];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    while (done == NO)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    STAssertNotNil(responseData, @"Error we didn't get any data from the server");
    
    //------------ check our results ---------------
    error = nil;
    queryResults = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    STAssertNil(error, @"Error responseData wasn't valid json");
    NSArray *jsonUsers = [queryResults objectForKey:@"users"];
    STAssertNotNil(jsonUsers, @"Error the users list is nil");
    STAssertTrue([jsonUsers count] > 0, @"Error test user was not returned");
}

- (void)testsUsersQueryAll
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *connectionAddress = @"users/_query";
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", serverAddress, connectionAddress];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    while (done == NO)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    STAssertNotNil(responseData, @"Error we didn't get any data from the server");
    
    //------------ check our results ---------------
    error = nil;
    queryResults = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    STAssertNil(error, @"Error responseData wasn't valid json");
    NSArray *jsonUsers = [queryResults objectForKey:@"users"];
    STAssertNotNil(jsonUsers, @"Error the users list is nil");
    STAssertTrue([jsonUsers count] > 0, @"Error we didn't receive any users");
}

- (void)testUsersQueryInvalid
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *invalidParam = @"barf";         //invalid query parameter
    NSString *connectionAddress = @"users/_query_user";
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?key=%@", serverAddress, connectionAddress, invalidParam];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    while (done == NO)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    STAssertNotNil(responseData, @"Error we didn't get any data from the server");
    
    //------------ check our results ---------------
    error = nil;
    queryResults = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    STAssertNil(error, @"Error responseData wasn't valid json");
    NSArray *jsonUsers = [queryResults objectForKey:@"users"];
    STAssertNotNil(jsonUsers, @"Error the users list is nil");
    STAssertTrue([jsonUsers count] == 0, @"Error the server is return a non-empty list of users");
}

- (void)testUsersQueryBadAddress
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *connectionAddress = @"usrs/_query";     //invalid connectionAddress
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", serverAddress, connectionAddress];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    while (done == NO)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    STAssertNotNil(responseData, @"Error we didn't get any data from the server");
    
    //------------ check our results ---------------
    error = nil;
    queryResults = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    STAssertNotNil(error, @"Error the server is returning a valid json object instead of the 404 page");
}

@end
