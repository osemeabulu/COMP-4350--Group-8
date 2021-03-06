//
//  CourseTests.m
//  cris-ios
//
//  Created by Rory Finnegan on 2013-03-24.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "CourseTests.h"
#import "Course.h"

@implementation CourseTests
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

-(void)testCourseGood
{
    Course *c = [[Course alloc] initWithCid:@"test1010" cname:@"test name" cdesc:@"test description" cflty:@"test Faculty"];
    
    [c addAVG:@"4"];
    
    STAssertTrue([c.cid isEqualToString:@"test1010"], @"Error with Course cid");
    STAssertTrue([c.cname isEqualToString:@"test name"], @"Error with Course cname");
    STAssertTrue([c.cdesc isEqualToString:@"test description"], @"Error with Course cdesc");
    STAssertTrue([c.cflty isEqualToString:@"test Faculty"], @"Error with Course faculty");
    STAssertTrue([c.cavg isEqualToString:@"4"], @"Error with Course average");
    
    assert(c);
}

- (void)testCourseQueryEmpty
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *connectionAddress = @"courses/_query";
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
    NSArray *jsonCourses = [queryResults objectForKey:@"courses"];
    STAssertNotNil(jsonCourses, @"Error the courses list is nil");
    STAssertTrue([jsonCourses count] > 0, @"Error the courses list is empty");
}

- (void)testCourseQueryInvalid
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *invalidParam = @"eoihfoefeh";         //invalid query parameter
    NSString *connectionAddress = @"courses/_query";
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
    NSArray *jsonCourses = [queryResults objectForKey:@"courses"];
    STAssertNotNil(jsonCourses, @"Error the courses list is nil");
    STAssertTrue([jsonCourses count] == 0, @"Error the courses list isn't empty");
}

- (void)testCourseQueryBadAddress
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *connectionAddress = @"course/_query";     //invalid connectionAddress
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

- (void)testCourseTopRatedValidAddress
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *connectionAddress = @"courses/_top_query";
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
    NSArray *jsonCourses = [queryResults objectForKey:@"courses"];
    STAssertNotNil(jsonCourses, @"Error the top rated courses list is nil");
    STAssertTrue([jsonCourses count] > 0, @"Error there are no top rated courses");
}

- (void)testCourseTopRatedBadAddress
{
    NSError *error;
    NSDictionary *queryResults;
    NSString *connectionAddress = @"course/_top_query";     //invalid connectionAddress
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
