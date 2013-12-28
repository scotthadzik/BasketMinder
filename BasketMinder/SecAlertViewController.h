//
//  SecAlertViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/28/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecAlertViewController;
@protocol SecAlertViewControllerDelegate <NSObject>

- (void)secAlertViewController:(SecAlertViewController *)controller didSelectAlert:(NSString *)alert;
@end

@interface SecAlertViewController : UITableViewController

@property (nonatomic, weak) id <SecAlertViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *alert;



@end
