//
//  ConfirmationViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/27/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *confirmationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UILabel *pickupDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmationTitle;
@property (weak, nonatomic) IBOutlet UILabel *dateTitle;
@property (strong, nonatomic) IBOutlet UILabel *pickupLocationTitle;
@property (strong, nonatomic) IBOutlet UILabel *pickupLocation;

@end
