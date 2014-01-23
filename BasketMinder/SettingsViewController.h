//
//  SettingsViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/27/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstAlertViewController.h"
#import "BillingInformationViewController.h"

static id gGlobalInstanceTabBar = nil;


@interface SettingsViewController : UITableViewController <FirstAlertViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UISwitch *setEventSwitch;

@property (weak, nonatomic) IBOutlet UITableViewCell *firstAlertCell;
@property (weak, nonatomic) IBOutlet UILabel *firstAlertTimeLabel;

- (void)checkForDefaultSet:(UILabel*)label setLabel:(NSString*)string alertDefault:(NSString*)alert;
- (void)changeCellColor:(BOOL) grey;

- (IBAction)setEventSwitch:(id)sender;

@end
