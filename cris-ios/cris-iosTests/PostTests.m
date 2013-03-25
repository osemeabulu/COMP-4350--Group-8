//
//  PostTests.m
//  cris-ios
//
//  Created by Rory Finnegan on 2013-03-25.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "PostTests.h"

@implementation PostTests
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

- (void)testPostQueryGood
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *userID = @"sam";
    NSString *connectionAddress = @"posts/_query_user";
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?key=%@", serverAddress, connectionAddress, userID];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    while (done == NO)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    STAssertNotNil(responseData, @"Error we didn't get any data from the server");
    
    //------------ check our results ---------------
    error = nil;
    queryResults = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    STAssertNil(error, @"Error responseData wasn't valid json");
    NSArray *jsonPosts = [queryResults objectForKey:@"posts"];
    STAssertNotNil(jsonPosts, @"Error the posts list is nil");
    STAssertTrue([jsonPosts count] > 0, @"Error sam doesn't have any posts");
    
    NSDictionary *post = [jsonPosts objectAtIndex:0];
    STAssertTrue([[post objectForKey:@"owner"] isEqualToString:userID], @"Error Post owner does not match");
}

- (void)testPostsQueryInvalid
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *invalidParam = @"no_user";         //invalid query parameter
    NSString *connectionAddress = @"posts/_query_user";
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
    NSArray *jsonPosts = [queryResults objectForKey:@"posts"];
    STAssertNotNil(jsonPosts, @"Error the posts list is nil");
    STAssertTrue([jsonPosts count] == 0, @"Error the server is return a non-empty list of posts for invalid user");
}

- (void)testPostsQueryBadAddress
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *connectionAddress = @"posts/_query_usr";     //invalid connectionAddress
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

- (void)testPostsQueryFollowersGood
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *userID = @"sam";
    NSString *connectionAddress = @"posts/_query_user_followers";
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?key=%@", serverAddress, connectionAddress, userID];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    while (done == NO)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    STAssertNotNil(responseData, @"Error we didn't get any data from the server");
    
    //------------ check our results ---------------
    error = nil;
    queryResults = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    STAssertNil(error, @"Error responseData wasn't valid json");
    NSArray *jsonPosts = [queryResults objectForKey:@"posts"];
    STAssertNotNil(jsonPosts, @"Error the posts list is nil");
    STAssertTrue([jsonPosts count] > 0, @"Error there are no post of followers");
    
    NSDictionary *post = [jsonPosts objectAtIndex:0];
    STAssertTrue([[post objectForKey:@"owner"] isEqualToString:@"chris"], @"Error Post owner does not match");
}

- (void)testPostsQueryFollowersInvalid
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *invalidParam = @"no_user";         //invalid query parameter
    NSString *connectionAddress = @"posts/_query_user_followers";
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
    NSArray *jsonPosts = [queryResults objectForKey:@"posts"];
    STAssertNotNil(jsonPosts, @"Error the posts list is nil");
    STAssertTrue([jsonPosts count] == 0, @"Error the server is return a non-empty list of posts for invalid user");
}

- (void)testPostsQueryFollowersBadAddress
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *connectionAddress = @"posts/_query_usr_followers";     //invalid connectionAddress
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

- (void)testsPostsQueryFollowingGood
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *userID = @"sam";
    NSString *connectionAddress = @"posts/_query_user_following";
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?key=%@", serverAddress, connectionAddress, userID];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    while (done == NO)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    STAssertNotNil(responseData, @"Error we didn't get any data from the server");
    
    //------------ check our results ---------------
    error = nil;
    queryResults = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    STAssertNil(error, @"Error responseData wasn't valid json");
    NSArray *jsonPosts = [queryResults objectForKey:@"posts"];
    STAssertNotNil(jsonPosts, @"Error the posts list is nil");
    STAssertTrue([jsonPosts count] > 0, @"Error there aren't any posts from people sam is following");
    
    NSDictionary *post = [jsonPosts objectAtIndex:0];
    STAssertTrue([[post objectForKey:@"owner"] isEqualToString:@"james"], @"Error Post owner does not match");
}

- (void)testsPostsQueryFollowingInvalid
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *invalidParam = @"no_user";         //invalid query parameter
    NSString *connectionAddress = @"posts/_query_user_following";
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
    NSArray *jsonPosts = [queryResults objectForKey:@"posts"];
    STAssertNotNil(jsonPosts, @"Error the posts list is nil");
    STAssertTrue([jsonPosts count] == 0, @"Error the server is return a non-empty list of posts for invalid user");
}

- (void)testsPostsQueryFollowingBadAddress
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *connectionAddress = @"posts/_query_usr_following";     //invalid connectionAddress
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
