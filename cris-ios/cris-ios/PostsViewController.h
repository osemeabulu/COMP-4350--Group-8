//
//  PostsViewController.h
//  cris-ios
//
//  Created by Scott Hofer on 2013-03-20.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *postsTableView;
    IBOutlet UISegmentedControl *control;
}

-(IBAction)switchcontrol:(id)sender;


@property (nonatomic,retain) IBOutlet UITableView *postsTableView;

@end
