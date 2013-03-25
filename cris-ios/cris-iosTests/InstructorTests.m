//
//  InstructorTests.m
//  cris-ios
//
//  Created by Rory Finnegan on 2013-03-25.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "InstructorTests.h"

@implementation InstructorTests
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

- (void)testInstructorsQueryEmpty
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *connectionAddress = @"instructors/_query";
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
    NSArray *jsonInstructors = [queryResults objectForKey:@"instructors"];
    STAssertNotNil(jsonInstructors, @"Error the instructors list is nil");
    STAssertTrue([jsonInstructors count] > 0, @"Error there are no instructors");
}

- (void)testInstructorsQueryInvalid
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *invalidParam = @"eoihfoefeh";         //invalid query parameter
    NSString *connectionAddress = @"instructors/_query";
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
    NSArray *jsonInstructors = [queryResults objectForKey:@"instructors"];
    STAssertNotNil(jsonInstructors, @"Error the instructors list is nil");
    STAssertTrue([jsonInstructors count] == 0, @"Error the server is return a non-empty list of instructors");
}

- (void)testInstructorsQueryBadAddress
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *connectionAddress = @"instructor/_query";     //invalid connectionAddress
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
