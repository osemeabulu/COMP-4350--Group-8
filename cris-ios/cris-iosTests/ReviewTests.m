//
//  ReviewTests.m
//  cris-ios
//
//  Created by Rory Finnegan on 2013-03-24.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "ReviewTests.h"
#import "Review.h"

@implementation ReviewTests
{
    //server address
    NSString* serverAddress;
    
    //response data from requests
    NSMutableData *createResponseData;
    NSMutableData *voteResponseData;
    
    //connections for the different requests
    NSURLConnection *createConn;
    NSURLConnection *voteConn;
}

- (void)setUp
{
    [super setUp];
    
    serverAddress = @"http://grp8-env-t6urakw4up.elasticbeanstalk.com";
}


- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    [voteResponseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [voteResponseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection != nil && connection == voteConn)
    {
        
    }
    
    else if (connection != nil && connection == createConn)
    {
        
    }
    
}

- (void)testExample
{
    //STFail(@"Unit tests are not implemented yet in cris-iosTests");
}

-(void)testReviewNormal
{
    Review *r = [[Review alloc] initWithCid:@"test1010" username:@"testUser" rdesc:@"i enjoyed taking this course as it was my first test course" rscr:@"3.5" upvote:@"0" downvote:@"0" rvote:@"0" pk:@"0"];
    
    STAssertTrue([r.cid isEqualToString:@"test1010"], @"Error with Reviews cid");
    STAssertTrue([r.username isEqualToString:@"testUser"], @"Error with Reviews username");
    STAssertTrue([r.rscr isEqualToString:@"3.5"], @"Error with Reviews scr");
    STAssertTrue([r.rdesc isEqualToString:@"i enjoyed taking this course ar it was my first test course"], @"Error with Reviews description");
    
    assert(r);
}

- (void)testReviewRequest
{
    //test review server requests
    NSString *connectionAddress = @"_submit_review";
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", serverAddress, connectionAddress];
    NSURL *testURL = [NSURL URLWithString:urlString];
    
    //[self postJSONObjects:jsonObj connection:self.createConn url:url];

}

- (void)postJSONObjects:(NSData *)jsonRequest connection:(NSURLConnection *)connection url:(NSURL *)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonRequest];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end

