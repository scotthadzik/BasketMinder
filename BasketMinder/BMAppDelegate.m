//
//  BMAppDelegate.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/18/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "BMAppDelegate.h"
#import <Parse/Parse.h>
#import "globals.h"

@implementation BMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:1.5];
    //set up connection between parse and app
    [Parse setApplicationId:@"LuL3dTksNAoKQbXhnPZyIq6N8Tff6CqiR5UazWrK" clientKey:@"bHkEInMK85NssaKvfCGDW6AmZVgPdC0cgfri8cfi"];
    
    //track launch app data
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //for push notifications
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    // Override point for customization after application launch.
    
    
    [self customizeUserInterface];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//for notifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
    
    
    NSString *token = [[[[newDeviceToken description]
              stringByReplacingOccurrencesOfString:@"<"withString:@""]
             stringByReplacingOccurrencesOfString:@">" withString:@""]
            stringByReplacingOccurrencesOfString: @" " withString: @""];
    //NSLog(@"token %@",token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}



//if app is open and notification sent
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

#pragma mark - Helper methods
-(void)customizeUserInterface{
//    //Customize the Nav Bar
//   // [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.553 green:0.435 blue:0.718 alpha:1.0]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBarBackground"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    
//
    [self customizeTabBar];
    //for pageview tutorial
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
}

-(void)customizeTabBar{
    //Customize the tab bar text color
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.608 green:0.22 blue:0.22 alpha:1.0], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    [tabBar setTranslucent:NO];
    
    UITabBarItem *tabBasket = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabConfirmation= [tabBar.items objectAtIndex:1];
    UITabBarItem *tabSettings= [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBlog= [tabBar.items objectAtIndex:3];
    //Basket
    tabBasket.selectedImage = [[UIImage imageNamed:@"basket_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBasket.image = [[UIImage imageNamed:@"basket"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBasket.title = @"Basket";
    //Confirmation
    tabConfirmation.selectedImage = [[UIImage imageNamed:@"confirmation_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabConfirmation.image = [[UIImage imageNamed:@"confirmation"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabConfirmation.title = @"Confirmation";
    //Settings
    tabSettings.selectedImage = [[UIImage imageNamed:@"settings_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabSettings.image = [[UIImage imageNamed:@"settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabSettings.title = @"Settings";
    //Blog
    tabBlog.selectedImage = [[UIImage imageNamed:@"moreInfo_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBlog.image = [[UIImage imageNamed:@"moreInfo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBlog.title = @"Blog";
    
}


@end
