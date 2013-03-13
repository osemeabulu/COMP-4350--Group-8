//
//  Course.h
//  cris-ios
//
//  Created by  on 2013-03-11.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property(strong, nonatomic) NSString *cid;
@property(strong, nonatomic) NSString *cname;
@property(strong, nonatomic) NSString *cdesc;
@property(strong, nonatomic) NSString *cflty;
@property(strong, nonatomic) NSString *cavg;

-(id)initWithCid:(NSString *)aCid cname:(NSString *)aCname cdesc:(NSString *)aCdesc cflty:(NSString *)aCflty;
-(void) addAVG: (NSString *)newAVG;
@end
