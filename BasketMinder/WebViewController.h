//
//  WebViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/23/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

//for webviewer
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (nonatomic) BOOL isLoggedIn;

- (void) sendLogin;
- (IBAction)settings:(id)sender;

@end
