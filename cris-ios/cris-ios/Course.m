//
//  Course.m
//  cris-ios
//
//  Created by  on 2013-03-11.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "Course.h"

@implementation Course

@synthesize cid, cname, cdesc, cflty;

-(id)initWithCid:(NSString *)aCid cname:(NSString *)aCname cdesc:(NSString *)aCdesc cflty:(NSString *)aCflty{
    self = [super init];
    if(self){
        self.cid = aCid;
        self.cname = aCname;
        self.cdesc = aCdesc;
        self.cflty = aCflty;
    }
    
    return self;
}


@end
