//
//  CourseDetailViewController.h
//  cris-ios
//
//  Created by Osemekhian Abulu on 2013-03-10.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface CourseDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *courseIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *facultyLabel;


@property (strong) Course *course;


- (IBAction)seeReviewButton:(id)sender;
- (IBAction)createReviewButton:(id)sender;

@end
