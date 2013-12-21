//
//  BMloginViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/20/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMloginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;



- (IBAction)loginButton:(id)sender;


@end
