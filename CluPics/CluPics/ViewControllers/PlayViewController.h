//
//  PlayViewController.h
//  CluPics
//
//  Created by Ryley Herrington on 2/28/14.
//  Copyright (c) 2014 Ryley Herrington. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField* usernameField;
@property (nonatomic, weak) IBOutlet UIImageView* img;
@property (nonatomic, weak)IBOutlet  UILabel* prompt;

-(IBAction)submit:(id)sender;
@end
