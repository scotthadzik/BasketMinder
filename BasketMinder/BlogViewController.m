//
//  BlogViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 1/13/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import "BlogViewController.h"

@interface BlogViewController ()

@end

@implementation BlogViewController

@synthesize webview, backButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *urlAddress = @"http://blog.bountifulbaskets.org/";
	[self displayWebView:urlAddress];
}

- (void) displayWebView: (NSString *) urlToLoad{
    
    NSURL *loginURL = [NSURL URLWithString:urlToLoad]; //start at this website
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:loginURL];
    [self.webview loadRequest:myRequest]; //load the webview
    self.webview.scalesPageToFit = YES;
}

@end
