//
//  Review.h
//  cris-ios
//
//  Created by Finn Wake on 2013-03-16.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Review : NSObject

@property(strong, nonatomic) NSString *cid;
@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSString *rdesc;
@property(strong, nonatomic) NSString *rscr;

-(id)initWithCid:(NSString *)aCid username:(NSString *)aUsername rdesc:(NSString *)aRdesc rscr:(NSString *)aRscr;
@end
