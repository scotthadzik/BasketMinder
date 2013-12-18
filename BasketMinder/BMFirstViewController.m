//
//  BMFirstViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/18/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "BMFirstViewController.h"

@interface BMFirstViewController ()

@end

@implementation BMFirstViewController

@synthesize myWebView = _myWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //--------------webView  start -----------------//
	
    NSURL *myURL = [NSURL URLWithString:@"http://contributions4.bountifulbaskets.org"];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    
    [self.myWebView loadRequest:myRequest];

    _myWebView.scalesPageToFit = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
