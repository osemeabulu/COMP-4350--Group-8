//
//  InstructorDetailViewController.h
//  cris-ios
//
//  Created by ian on 2013-03-25.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructorDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *instructorsTableView;
}
@property (weak, nonatomic) IBOutlet UITableView *instructorsTableView;
@property (weak, nonatomic) IBOutlet UILabel *instructorLabel;
@property (strong) NSString *instructor;
@property (nonatomic, strong) NSMutableArray *courses;

@end
