//
//  TopRatedViewController.h
//  cris-ios
//
//  Created by Osemekhian Abulu on 2013-03-09.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopRatedViewController : UITableViewController{
    NSMutableArray *topRatedCourses;
}

@property (nonatomic, retain) IBOutlet UITableView *topRatedTable;

@end
