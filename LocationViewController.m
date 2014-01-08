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

@implementation LocationViewController{
    NSString *urlAddress;
}

@synthesize locationWebView;



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    
    self.locationWebView.delegate = self;
	// Do any additional setup after loading the view.
    
    
    [self checkForTestLogin];
    
    
    //append the token to the urladdress
    NSString *token=  [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
    NSLog(@"token %@", token);
    urlAddress = [urlAddress stringByAppendingString:token];
    //go to location view website
    NSURL *locationsURL = [NSURL URLWithString:urlAddress]; //start at this website
    NSURLRequest *webRequest = [NSURLRequest requestWithURL:locationsURL];
    [self.locationWebView loadRequest:webRequest]; //load the webview
    self.locationWebView.scalesPageToFit = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self checkForTestLogin];
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


@end
