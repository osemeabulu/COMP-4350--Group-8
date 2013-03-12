//
//  CourseDetailViewController.m
//  cris-ios
//
//  Created by Osemekhian Abulu on 2013-03-10.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "CourseDetailViewController.h"

@interface CourseDetailViewController ()

@end

@implementation CourseDetailViewController

@synthesize courseIdLabel, courseNameLabel, courseDescriptionLabel, averageRatingLabel, facultyLabel, course;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //courseNameLabel =
        //courseDescriptionLabel.text=
        //averageRatingLabel.text=
        //facultyLabel.text=
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.courseIdLabel.text= self.course.cid;
    self.courseNameLabel.text = self.course.cname;
    self.courseDescriptionLabel.text = self.course.cdesc;
    self.facultyLabel.text = self.course.cflty;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)seeReviewButton:(id)sender {
}

- (IBAction)createReviewButton:(id)sender {
}
@end
