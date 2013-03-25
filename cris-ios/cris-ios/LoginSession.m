//
//  LoginSession.m
//  cris-ios
//
//  Created by ian on 2013-03-24.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "LoginSession.h"

@implementation LoginSession

static LoginSession *sharedInstance = nil;

+(LoginSession *) sharedInstance {
    static LoginSession *mysharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mysharedInstance = [[self alloc] init];
    });
    return mysharedInstance;
                    
}

-(id)init {
    if (self = [super init]) {
        _user = nil;
    }
    return self;
}

@end
