//
//  FeedbackViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 1/4/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface FeedbackViewController : UIViewController <MFMailComposeViewControllerDelegate>
- (IBAction)sendFeedback:(id)sender;

@end
