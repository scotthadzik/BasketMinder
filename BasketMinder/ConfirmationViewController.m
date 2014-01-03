//
//  ConfirmationViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/27/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "ConfirmationViewController.h"
#import "WebViewController.h"

@interface ConfirmationViewController ()

@end

@implementation ConfirmationViewController

@synthesize confirmationLabel;
@synthesize pickupDateLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkForConfirmationNumber];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self checkForConfirmationNumber];
}
- (void)checkForConfirmationNumber{
    NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"confirmationNumber"];
    NSString *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"pickupDate"];
    if (temp != NULL){
        self.confirmationLabel.text = temp;
        self.pickupDateLabel.text = date;
    }
}

@end
