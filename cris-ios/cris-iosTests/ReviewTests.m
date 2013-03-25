//
//  ReviewTests.m
//  cris-ios
//
//  Created by Rory Finnegan on 2013-03-24.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "ReviewTests.h"
#import "Review.h"

@interface ReviewTests ()
    - (void)postJSONObjects:(NSData *)jsonRequest connection:(NSURLConnection *)connection url:(NSURL *)url;
@end

@implementation ReviewTests
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
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    //NSLog(responseString);
    //NSError *err = nil;
    //submitResults = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&err];
    
    //NSLog([NSString stringWithFormat:@"JSON conversion returns %@", [err description]]);
}

-(void)testReviewNormal
{
    Review *r = [[Review alloc] initWithCid:@"test1010" username:@"testUser" rdesc:@"i enjoyed taking this course as it was my first test course" rscr:@"3.5" upvote:@"0" downvote:@"0" rvote:@"0" pk:@"0"];
    
    STAssertTrue([r.cid isEqualToString:@"test1010"], @"Error with Reviews cid");
    STAssertTrue([r.username isEqualToString:@"testUser"], @"Error with Reviews username");
    STAssertTrue([r.rscr isEqualToString:@"3.5"], @"Error with Reviews scr");
    STAssertTrue([r.rdesc isEqualToString:@"i enjoyed taking this course as it was my first test course"], @"Error with Reviews description");
    
    assert(r);
}

- (void)testReviewSubmitGood
{
    NSError *error;
    NSDictionary *submitResults;
    
    //-------- create json object for review -------
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setValue:@"Comp4350" forKey:@"cid"];
    [info setValue:@"4" forKey:@"rscr"];
    [info setValue:@"Test Review" forKey:@"rdesc"];
    [info setValue:[NSNumber numberWithInt:(0)] forKey:@"rvote"];
    [info setValue:[NSNumber numberWithInt:(0)] forKey:@"upvote"];
    [info setValue:[NSNumber numberWithInt:(0)] forKey:@"downvote"];
    NSData *jsonObj = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    STAssertNotNil(jsonObj, @"Error jsonified review is nil");
    
    //------ set up review submit request ----------
    NSString *connectionAddress = @"reviews/_submit_review";
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", serverAddress, connectionAddress];
    NSURL *testURL = [NSURL URLWithString:urlString];
    STAssertNotNil(testURL, @"Error testURL for review submission is nil");
    
    //------------- make the request ---------------
    [self postJSONObjects:jsonObj connection:connection url:testURL];
    
    //wait for response data
    while (done == NO)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    STAssertNotNil(responseData, @"Error we didn't get any data from the server");
    
    //------------ check our results ---------------
    error = nil;
    submitResults = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    //NSLog([NSString stringWithFormat:@"JSON serialization error = %@", [error description]]);
    STAssertNil(error, @"Error submitResult wasn't a valid JSON object");
    STAssertTrue([[submitResults objectForKey:@"rdesc"] isEqualToString:[info objectForKey:@"rdesc"]], @"Error review description don't match");
    STAssertTrue([[submitResults objectForKey:@"rscr"] isEqualToString:[info objectForKey:@"rscr"]], @"Error review scores don't match");
}

- (void)testReviewSubmitBadAddress
{
    NSError *error;
    NSDictionary *submitResults;
    
    //-------- create json object for review -------
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setValue:@"Comp4350" forKey:@"cid"];
    [info setValue:@"4" forKey:@"rscr"];
    [info setValue:@"Test Review" forKey:@"rdesc"];
    [info setValue:[NSNumber numberWithInt:(0)] forKey:@"rvote"];
    [info setValue:[NSNumber numberWithInt:(0)] forKey:@"upvote"];
    [info setValue:[NSNumber numberWithInt:(0)] forKey:@"downvote"];
    NSData *jsonObj = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    STAssertNotNil(jsonObj, @"Error jsonified review is nil");
    
    //------ set up review submit request ----------
    NSString *connectionAddress = @"review/_submit_review";     //invalid submission address
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", serverAddress, connectionAddress];
    NSURL *testURL = [NSURL URLWithString:urlString];
    STAssertNotNil(testURL, @"Error testURL for review submission is nil");
    
    //------------- make the request ---------------
    [self postJSONObjects:jsonObj connection:connection url:testURL];
    
    //wait for response data
    while (done == NO)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    STAssertNotNil(responseData, @"Error we didn't get any data from the server");
    
    //------------ Make sure that our response isn't valid json (should be the 404 page) ---------------
    error = nil;
    submitResults = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    //NSLog([NSString stringWithFormat:@"JSON serialization error = %@", [error description]]);
    STAssertNotNil(error, @"Error our invalid review submission worked when it wasn't suppose to.");
}

- (void)postJSONObjects:(NSData *)jsonRequest connection:(NSURLConnection *)connection url:(NSURL *)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    STAssertNotNil(request, @"postJSONObjects: Error request is nil");
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonRequest];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

@end

