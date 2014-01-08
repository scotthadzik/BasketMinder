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
@synthesize confirmationTitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizePage];
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
- (void)customizePage{
    
    confirmationLabel.font = [UIFont fontWithName:@"IstokWeb-Regular" size:18];
    pickupDateLabel.font = [UIFont fontWithName:@"IstokWeb-Regular" size:18];
    confirmationTitle.font = [UIFont fontWithName:@"IstokWeb-Regular" size:18];
}

@end
