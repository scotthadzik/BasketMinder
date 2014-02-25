//
//  NewParticipantViewController.m
//  BasketMinder
//
//  Created by Scott Hadzik on 2/25/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import "NewParticipantViewController.h"

@interface NewParticipantViewController ()

@end

@implementation NewParticipantViewController

@synthesize PartWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeView];
   
    NSString *urlAddress = @"http://www.bountifulbaskets.org/?page_id=233";
	[self displayWebView:urlAddress];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self customizeView];
}
- (void) displayWebView: (NSString *) urlToLoad{
    
    NSURL *loginURL = [NSURL URLWithString:urlToLoad]; //start at this website
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:loginURL];
    [self.PartWebView loadRequest:myRequest]; //load the webview
    self.PartWebView.scalesPageToFit = YES;
}

-(void)customizeView{
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
}
- (IBAction)backButton:(id)sender {
    
    UIViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rootViewController"]; //root view
    [self presentViewController:loginViewController animated:YES completion:nil];
}
@end
