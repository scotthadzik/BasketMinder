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

- (void)viewDidLoad
{
    [super viewDidLoad];

}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    WebViewController *webViewVariables = (WebViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
    
    NSString *temp = webViewVariables.confirmationNumber;
    if (temp != NULL){
        self.confirmationLabel.text = temp;
    }
}

@end
