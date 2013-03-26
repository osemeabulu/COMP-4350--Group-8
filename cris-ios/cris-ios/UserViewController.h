//
//  UserViewController.h
//  cris-ios
//
//  Created by Noel Ganotisi on 2013-03-21.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *usersTableView;
    IBOutlet UISegmentedControl *control;
}

-(IBAction)switchcontrol:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UILabel *currUserLbl;

@property (weak, nonatomic) IBOutlet UILabel *userLbl;
@property (weak, nonatomic) IBOutlet UILabel *passLbl;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic,retain) IBOutlet UITableView *usersTableView;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)loginButton:(id)sender;
- (IBAction)logoutButton:(id)sender;

@end
