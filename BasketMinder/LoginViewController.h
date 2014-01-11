//
//  LoginViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 1/2/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *bbTitle;

- (IBAction)login:(id)sender;

@end
