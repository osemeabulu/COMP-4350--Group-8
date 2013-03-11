//
//  CourseDetailViewController.h
//  cris-ios
//
//  Created by Osemekhian Abulu on 2013-03-10.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoursesTableViewController.h"

@interface CourseDetailViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *facultyLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;


- (IBAction)backButton:(id)sender;
- (IBAction)seeReviewButton:(id)sender;
- (IBAction)createReviewButton:(id)sender;

@end
