//
//  cris_iosTests.m
//  cris-iosTests
//
//  Created by Scott Hofer on 2013-03-08.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "cris_iosTests.h"
#import "Course.h"
#import "Review.h"

@implementation cris_iosTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}


- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    //STFail(@"Unit tests are not implemented yet in cris-iosTests");
}

-(void)testCourses
{
    Course *c = [[Course alloc] initWithCid:@"test1010" cname:@"test name" cdesc:@"test description" cflty:@"test Faculty"];
    
    [c addAVG:@"4"];
        
    STAssertTrue([c.cid isEqualToString:@"test1010"], @"Error with Course cid");
    STAssertTrue([c.cname isEqualToString:@"test name"], @"Error with Course cname");
    STAssertTrue([c.cdesc isEqualToString:@"test description"], @"Error with Course cdesc");
    STAssertTrue([c.cflty isEqualToString:@"test Faculty"], @"Error with Course faculty");
    STAssertTrue([c.cavg isEqualToString:@"4"], @"Error with Course average");
    
    assert(c);
    
    //print course
}

-(void)testReviews
{
    Review *r = [[Review alloc] initWithCid:@"test1010" username:@"testUser" rdesc:@"i enjoyed taking this course as it was my first test course" rscr:@"3.5"];
    
    STAssertTrue([r.cid isEqualToString:@"test1010"], @"Error with Reviews cid");
    STAssertTrue([r.username isEqualToString:@"testUser"], @"Error with Reviews username");
    STAssertTrue([r.rscr isEqualToString:@"3.5"], @"Error with Reviews scr");
    STAssertTrue([r.rdesc isEqualToString:@"i enjoyed taking this course ar it was my first test course"], @"Error with Reviews description");
    
    
    assert(r);
}

-(void)testConnection
{
    //add connenction tests
}


@end
