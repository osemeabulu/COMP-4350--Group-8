//
//  AppDelegate.h
//  cris-ios
//
//  Created by Scott Hofer on 2013-03-08.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window;
    NSString *baseURL;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *baseURL;

@end
