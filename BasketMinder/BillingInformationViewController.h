//
//  BillingInformationViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 1/4/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICKeyChainStore.h"


@interface BillingInformationViewController : UITableViewController

@property (retain, nonatomic) IBOutlet UITextField *nameOnCard;
@property (retain, nonatomic) IBOutlet UITextField *cardNumber;
@property (strong, nonatomic) IBOutlet UITextField *billingAddress;
@property (strong, nonatomic) IBOutlet UITextField *billingCity;
@property (strong, nonatomic) IBOutlet UITextField *billingState;
@property (strong, nonatomic) IBOutlet UITextField *billingZipCode;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveText;

- (IBAction)saveButton:(id)sender;


@end
