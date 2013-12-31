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

static id gGlobalInstanceTabBar = nil;


@interface SettingsViewController : UITableViewController <SecAlertViewControllerDelegate, FirstAlertViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UISwitch *setEventSwitch;

@property (weak, nonatomic) IBOutlet UITableViewCell *firstAlertCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *secAlertCell;
@property (weak, nonatomic) IBOutlet UILabel *firstAlertTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secAlertTimeLabel;

- (void)checkForDefaultSet:(UILabel*)label setLabel:(NSString*)string alertDefault:(NSString*)alert;
- (void)checkForValidLogin;
- (void)changeCellColor:(BOOL) grey;

- (IBAction)setEventSwitch:(id)sender;
+ (UITabBarController *) tabBarController;

@end
