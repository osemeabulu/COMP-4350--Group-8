//
//  ReviewViewController.h
//  cris-ios
//
//  Created by Finn Wake on 2013-03-17.
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

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;

@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

@property (weak, nonatomic) IBOutlet UILabel *dislikeLabel;

@property (strong) Review *review;

@property (strong) CourseDetailViewController *cdvc;

- (IBAction)like:(id)sender;

- (IBAction)dislike:(id)sender;



@end
