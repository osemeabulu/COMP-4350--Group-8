//
//  LoginSession.h
//  cris-ios
//
//  Created by ian on 2013-03-24.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <Foundation/Foundation.h>

//A singleton used to store the currently logged in user
@interface LoginSession : NSObject


@property(strong, nonatomic) NSString *user;

+(id)sharedInstance;
@end
