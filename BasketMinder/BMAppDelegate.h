//
//  BMAppDelegate.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/18/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

@class KeychainItemWrapper, BillingInformationViewController;

#import <UIKit/UIKit.h>

@interface BMAppDelegate : UIResponder <UIApplicationDelegate>{
    KeychainItemWrapper *passwordItem;
    KeychainItemWrapper *accountNumberItem;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) KeychainItemWrapper *passwordItem;
@property (nonatomic, retain) KeychainItemWrapper *accountNumberItem;

@end
