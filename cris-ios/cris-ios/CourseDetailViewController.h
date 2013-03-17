//
//  CourseDetailViewController.h
//  cris-ios
//
//  Created by Osemekhian Abulu on 2013-03-10.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewViewController.h"
#import "Course.h"

@interface CourseDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *courseIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *facultyLabel;
@property (weak, nonatomic) IBOutlet UITableView *reviewList;




@property (strong) Course *course;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (IBAction)seeReviewButton:(id)sender;
- (IBAction)createReviewButton:(id)sender;

@end
