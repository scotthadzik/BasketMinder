//
//  InitialLocationViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 2/24/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import "InitialLocationViewController.h"

#ifdef __APPLE__
#include "TargetConditionals.h"
#endif

@interface InitialLocationViewController ()

@end

@implementation InitialLocationViewController{
    NSString *urlAddress;
}

@synthesize locationWebview, saveText;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    self.locationWebview.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self checkForTestLogin];
    
    //check to see if running in simulator
#if !(TARGET_IPHONE_SIMULATOR)
    //append the token to the urladdress
    NSString *token=  [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
    if (token != nil){
        urlAddress = [urlAddress stringByAppendingString:token];
    }
    NSLog(@"Device Token = %@", token);
    NSLog(@"urlAddress = %@", urlAddress);
    
#endif
    
    //go to location view website
    NSURL *locationsURL = [NSURL URLWithString:urlAddress]; //start at this website
    NSURLRequest *webRequest = [NSURLRequest requestWithURL:locationsURL];
    [self.locationWebview loadRequest:webRequest]; //load the webview
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Preferred Location" message:@"This page is to set your preferred locations for basket pickup. You will be notified when baskets are available in these locations. If you need to make any changes later, go to settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}


- (void)checkForTestLogin{
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"preferEmail"];
    if ([email isEqualToString:@"tester1234"]) {
        urlAddress = @"http://www.tankjig.com/dev/locations.php?phoneid=";
    }
    else{
        urlAddress = @"http://www.tankjig.com/locations.php?phoneid=";
    }
}


- (IBAction)saveButton:(id)sender {
        UIViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageRootViewController"]; //tutorial page
        [self presentViewController:loginViewController animated:YES completion:nil];
}
@end
