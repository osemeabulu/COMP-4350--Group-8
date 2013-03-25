//
//  NewPostViewController.h
//  cris-ios
//
//  Created by Scott Hofer on 2013-03-20.
//  Copyright (c) 2013 Scott Hofer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPostViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *postText;
- (IBAction)createPost:(id)sender;

@end
