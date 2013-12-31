//
//  WebViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/23/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate, NSURLConnectionDelegate, UITabBarControllerDelegate>

//for webviewer
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) EKEventStore *eventStore;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSString *confirmationNumber;



- (NSString *)regexTheString:(NSString*)string pattern:(NSString*)pattern;

- (NSTimeInterval)calcAlarmTime:(NSString *) alarmTime;

- (void) sendLogin;

@end
