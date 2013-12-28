//
//  FirstAlertViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/28/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FirstAlertViewController;
@protocol FirstAlertViewControllerDelegate <NSObject>

- (void)firstAlertViewController:(FirstAlertViewController *)controller didSelectAlert:(NSString *)alert;
@end

@interface FirstAlertViewController : UITableViewController

@property (nonatomic, weak) id <FirstAlertViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *alert;

@end
