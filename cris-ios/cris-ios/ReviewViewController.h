//
//  ReviewViewController.h
//  cris-ios
//
//  Created by Finn Wake on 2013-03-17.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Review.h"

@interface ReviewViewController : UIViewController <UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *courseLabel;

@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *scorePicker;

@property (weak, nonatomic) IBOutlet UITextView *descText;

@property (strong) Review *review;
@end
