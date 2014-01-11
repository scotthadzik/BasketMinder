//
//  ConfirmationViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/27/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "ConfirmationViewController.h"
#import "WebViewController.h"
#import "globals.h"

@interface ConfirmationViewController ()

@end

@implementation ConfirmationViewController

@synthesize confirmationLabel, confirmationTitle;
@synthesize pickupDateLabel, dateTitle;
@synthesize pickupLocation, pickupLocationTitle;

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
    NSString *pickupLocationName = [[NSUserDefaults standardUserDefaults] objectForKey:@"pickupName"];
    NSString *pickupLocationAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"pickupAddress"];
    NSString *pickupLocationCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"pickupCity"];
    NSString *pickupLocationState = [[NSUserDefaults standardUserDefaults] objectForKey:@"pickupState"];

    pickupLocationName = [pickupLocationName stringByAppendingString:@"\n"];
    pickupLocationName = [pickupLocationName stringByAppendingString:pickupLocationAddress];
    pickupLocationName = [pickupLocationName stringByAppendingString:@"\n"];
    pickupLocationName = [pickupLocationName stringByAppendingString:pickupLocationCity];
    //pickupLocationName = [pickupLocationName stringByAppendingString:@", "];
    pickupLocationName = [pickupLocationName stringByAppendingString:pickupLocationState];
    
    
    if (temp != NULL){
        self.confirmationLabel.text = temp;
        self.pickupDateLabel.text = date;
        self.pickupLocation.text = pickupLocationName;
    }
}
- (void)customizePage{
    
    globals *sharedData = [globals sharedData];
    
    confirmationLabel.font = [UIFont fontWithName:@"IstokWeb-Regular" size:18];
    pickupDateLabel.font = [UIFont fontWithName:@"IstokWeb-Regular" size:18];
    confirmationTitle.font = [UIFont fontWithName:@"IstokWeb-Regular" size:18];
    dateTitle.font = [UIFont fontWithName:@"IstokWeb-Regular" size:18];
    pickupLocationTitle.font = [UIFont fontWithName:@"IstokWeb-Regular" size:18];
   
    confirmationLabel.layer.cornerRadius = 5;
    confirmationLabel.layer.borderWidth = 1.5;
    confirmationLabel.layer.borderColor = sharedData.redColor.CGColor;
    
    pickupDateLabel.layer.cornerRadius = 5;
    pickupDateLabel.layer.borderWidth = 1.5;
    pickupDateLabel.layer.borderColor = sharedData.redColor.CGColor;
    
    pickupLocation.layer.cornerRadius = 5;
    pickupLocation.layer.borderWidth = 1.5;
    pickupLocation.layer.borderColor = sharedData.redColor.CGColor;
}

@end
