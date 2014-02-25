//
//  InitialLocationViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 2/24/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitialLocationViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveText;
@property (strong, nonatomic) IBOutlet UIWebView *locationWebview;
- (IBAction)saveButton:(id)sender;

@end
