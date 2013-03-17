//
//  ReviewViewController.m
//  cris-ios
//
//  Created by Finn Wake on 2013-03-17.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import "ReviewViewController.h"

@interface ReviewViewController ()

@end

@implementation ReviewViewController

@synthesize courseLabel;
@synthesize userLabel;
@synthesize scorePicker;
@synthesize descText;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.courseLabel.text = self.review.cid;
    
    NSRange textRange = [self.review.username rangeOfString:@"null"];
    if (textRange.location != NSNotFound)
    {
        self.userLabel.text = [NSString stringWithFormat:@"N/A"];
    }
    
    else
    {
        self.userLabel.text = self.review.username;
    }
    
    self.scorePicker.dataSource = self;
    self.scorePicker.delegate = self;
    [self.scorePicker reloadAllComponents];
    [self.scorePicker selectRow:self.review.rscr.intValue - 1 inComponent:0 animated:YES];
    self.descText.delegate = self;
    self.descText.text = self.review.rdesc;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)imageForRating:(int)rating
{
	switch (rating)
	{
		case 1: return [UIImage imageNamed:@"1StarSmall.png"];
		case 2: return [UIImage imageNamed:@"2StarsSmall.png"];
		case 3: return [UIImage imageNamed:@"3StarsSmall.png"];
		case 4: return [UIImage imageNamed:@"4StarsSmall.png"];
		case 5: return [UIImage imageNamed:@"5StarsSmall.png"];
	}
	return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIImageView *result = [[UIImageView alloc] initWithImage: [self imageForRating: row + 1]];
    return result;
}


@end
