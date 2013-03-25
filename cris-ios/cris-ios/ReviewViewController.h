//
//  ReviewViewController.h
//  cris-ios
//
//  Created by Rory Finnegan on 2013-03-17.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDetailViewController.h"
#import "Review.h"

@interface ReviewViewController : UIViewController <UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *courseLabel;

@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *scorePicker;

@property (weak, nonatomic) IBOutlet UITextView *descText;

@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;

@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

@property (weak, nonatomic) IBOutlet UILabel *dislikeLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;


@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIButton *saveChanges;

@property (strong) Review *review;

@property (strong) CourseDetailViewController *cdvc;

- (IBAction)like:(id)sender;

- (IBAction)dislike:(id)sender;

- (IBAction)create:(id)sender;

- (IBAction)follow:(id)sender;

- (IBAction)edit:(id)sender;

- (IBAction)del:(id)sender;



@end
