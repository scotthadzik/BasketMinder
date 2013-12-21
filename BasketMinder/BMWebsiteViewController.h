//
//  BMWebsiteViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/20/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMWebsiteViewController : UIViewController <UIWebViewDelegate>

//for webviewer
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (nonatomic) BOOL isLoggedIn;

- (void) sendLogin;
- (IBAction)logoutButton:(id)sender;

@end
