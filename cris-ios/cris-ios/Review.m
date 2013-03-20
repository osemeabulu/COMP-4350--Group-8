//
//  Review.m
//  cris-ios
//
//  Created by Rory Finnegan on 2013-03-16.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "Review.h"

@implementation Review


@synthesize cid, username, rdesc, rscr, upvote, downvote, pk, index;

-(id)initWithCid:(NSString *)aCid username:(NSString *)aUsername rdesc:(NSString *)aRdesc rscr:(NSString *)aRscr upvote:(NSString *)aUpvote downvote:(NSString *)aDownvote rvote:(NSString *)aRvote pk:(NSString *)aPk;
{
    self = [super init];
    if(self){
        self.pk = aPk;
        self.cid = aCid;
        self.username = aUsername;
        self.rdesc = aRdesc;
        self.rscr = aRscr;
        self.upvote = aUpvote;
        self.downvote = aDownvote;
        self.rvote = aRvote;
    }
    
    return self;
}

@end
