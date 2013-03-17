//
//  Review.m
//  cris-ios
//
//  Created by Finn Wake on 2013-03-16.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "Review.h"

@implementation Review


@synthesize cid, username, rdesc, rscr;

-(id)initWithCid:(NSString *)aCid username:(NSString *)aUsername rdesc:(NSString *)aRdesc rscr:(NSString *)aRscr
{
    self = [super init];
    if(self){
        self.cid = aCid;
        self.username = aUsername;
        self.rdesc = aRdesc;
        self.rscr = aRscr;
    }
    
    return self;
}

@end
