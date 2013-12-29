//
//  LocationViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/27/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

@synthesize locationWebView;



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationWebView.delegate = self;
	// Do any additional setup after loading the view.
    NSString *urlAddress = @"http://162.243.202.112/locations.php?phoneid=";
    
    NSString *token=  [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
    NSLog(@"token %@", token);
    urlAddress = [urlAddress stringByAppendingString:token];
    NSURL *locationsURL = [NSURL URLWithString:urlAddress]; //start at this website
    NSURLRequest *webRequest = [NSURLRequest requestWithURL:locationsURL];
    [self.locationWebView loadRequest:webRequest]; //load the webview
    self.locationWebView.scalesPageToFit = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
}



@end
