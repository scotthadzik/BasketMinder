//
//  SettingsViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/27/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end
