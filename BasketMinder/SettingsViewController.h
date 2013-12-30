//
//  SettingsViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/27/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecAlertViewController.h"
#import "FirstAlertViewController.h"

@interface SettingsViewController : UITableViewController <SecAlertViewControllerDelegate, FirstAlertViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UILabel *firstDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *secDetailLabel;

- (void)checkForDefaultSet:(UILabel*)label setLabel:(NSString*)string alertDefault:(NSString*)alert;

@end
