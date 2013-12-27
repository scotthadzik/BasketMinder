//
//  WebViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/23/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "WebViewController.h"
#import <EventKit/EventKit.h>

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize myWebView; //= _myWebView;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //--------------webView  start -----------------//
    
    self.myWebView.delegate = self;//allows for call of webViewDidFinishLoad
    //NSString *urlAddress = @"http://contributions4.bountifulbaskets.org";
    NSString *urlAddress = @"http://hadzik.dyndns.org/bb/livepurchase/1.htm";
    http://hadzik.dyndns.org/bb/livepurchase/1.htm
    [self displayWebView:urlAddress];
    
    //--------------webView  end -----------------//

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self sendLogin]; //call the login for the first load of the site
    
    NSError *error = NULL;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"Contribution confirmation number: \\d{10}" options:NSRegularExpressionCaseInsensitive error:&error];
    //string of html page
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSString *matchDate;
    NSString *confirmationNumber;
    NSString *month,*day,*year,*time, *amORpm;
    //count the number of times key found on page
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    
    NSArray *results = [regex matchesInString:htmlString options: 0 range:NSMakeRange(0, [htmlString length])];
    
    if(numberOfMatches > 0){
        for (NSTextCheckingResult *ntcr in results) {
            confirmationNumber = [htmlString substringWithRange:ntcr.range];
        }
        
        //find the date of pickup
        NSRegularExpression *regex2 = [[NSRegularExpression alloc] initWithPattern:@"pickup \\w{1,20}, (\\w{1,10}) (\\d{1,2}), (\\d\\d\\d\\d), (\\d{1,2}:\\d\\d)" options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *resultsdate = [regex2 matchesInString:htmlString options: 0 range:NSMakeRange(0, [htmlString length])];
        for (NSTextCheckingResult *ntcr in resultsdate) {
            matchDate = [htmlString substringWithRange:ntcr.range];
        }
        
            //get the month
            NSRegularExpression *regexMonth = [[NSRegularExpression alloc] initWithPattern:@", \\w{1,10} " options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *resultsMonth = [regexMonth matchesInString:matchDate options: 0 range:NSMakeRange(0, [matchDate length])];
            for (NSTextCheckingResult *ntcr in resultsMonth) {
                month = [matchDate substringWithRange:ntcr.range];
                month = [month stringByReplacingOccurrencesOfString:@" " withString:@""]; //delete spaces and ,
                month = [month stringByReplacingOccurrencesOfString:@"," withString:@""];
                month = [month substringToIndex:3]; //only use the first 3 letters of month
            }

            //get the day
            NSRegularExpression *regexDay = [[NSRegularExpression alloc] initWithPattern:@" \\d{1,2}, " options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *resultsDay = [regexDay matchesInString:matchDate options: 0 range:NSMakeRange(0, [matchDate length])];
            for (NSTextCheckingResult *ntcr in resultsDay) {
                day = [matchDate substringWithRange:ntcr.range];
                day = [day stringByReplacingOccurrencesOfString:@" " withString:@""];//delete spaces and ,
                day = [day stringByReplacingOccurrencesOfString:@"," withString:@""];
            }
            
            //get the year
            NSRegularExpression *regexYear = [[NSRegularExpression alloc] initWithPattern:@"\\d\\d\\d\\d" options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *resultsYear = [regexYear matchesInString:matchDate options: 0 range:NSMakeRange(0, [matchDate length])];
            for (NSTextCheckingResult *ntcr in resultsYear) {
                year = [matchDate substringWithRange:ntcr.range];
            }
            
            //get the time
            NSRegularExpression *regexTime = [[NSRegularExpression alloc] initWithPattern:@"\\d{1,2}:\\d\\d" options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *resultsTime = [regexTime matchesInString:matchDate options: 0 range:NSMakeRange(0, [matchDate length])];
            for (NSTextCheckingResult *ntcr in resultsTime) {
                time = [matchDate substringWithRange:ntcr.range];
                NSString *timeOfDay = time;
               
                //determine if it is AM or PM
                if(time.length == 4){//hour is single digit
                    timeOfDay = [timeOfDay substringToIndex:1];
                }else{
                    timeOfDay = [timeOfDay substringToIndex:2];
                }
                NSLog(@"timeOfDay: %@", timeOfDay);
                int hour = [timeOfDay intValue];
                if (hour >= 1 && hour <= 5) {//this is an afternoon value
                    amORpm = @" PM";
                }
                else if(hour == 12){    //this is an afternoon value
                    amORpm = @" PM";
                }
                else{                   //this is an morning value
                    amORpm = @" AM";
                }
            }
        
            //setup day string
            NSString *dateString = month;
            dateString = [dateString stringByAppendingString:@"-"];
            dateString = [dateString stringByAppendingString:day];
            dateString = [dateString stringByAppendingString:@"-"];
            dateString = [dateString stringByAppendingString:year];
            dateString = [dateString stringByAppendingString:@"-"];
            dateString = [dateString stringByAppendingString:time];
            dateString = [dateString stringByAppendingString:amORpm];
            NSLog(@"%@", dateString);
        
        
        
        
            //convert string to date
            NSDateFormatter *longDate = [[NSDateFormatter alloc] init];
            [longDate setDateFormat:@"MMM-dd-yyyy-hh:mm a"];
            NSDate *pickupDate = [longDate dateFromString:dateString];
            NSLog(@"date is %@",[longDate stringFromDate:pickupDate]);
        
        
            //store event
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) {
                return;
            }
            EKEvent *event = [EKEvent eventWithEventStore:store];
            event.title = @"Bountiful Basket Pickup";
            event.startDate = pickupDate; //today
            event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
                NSMutableArray *alarmsArray = [[NSMutableArray alloc] init];
                EKAlarm *alarm1 = [EKAlarm alarmWithRelativeOffset:-3600]; // 1 Hour
                EKAlarm *alarm2 = [EKAlarm alarmWithRelativeOffset:-86400]; // 1 Day
                
                [alarmsArray addObject:alarm1];
                [alarmsArray addObject:alarm2];
                event.alarms = alarmsArray;
                
            [event setCalendar:[store defaultCalendarForNewEvents]];
            NSError *err = nil;
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            NSString *savedEventId = event.eventIdentifier;  //this is so you can access this event later
        }];
        
    }
    
    
}

- (void) displayWebView: (NSString *) urlToLoad{
    
    NSURL *loginURL = [NSURL URLWithString:urlToLoad]; //start at this website
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:loginURL];
    [self.myWebView loadRequest:myRequest]; //load the webview
    self.myWebView.scalesPageToFit = YES;
}

- (void) sendLogin{
    
    NSString *emailString   =  [[NSUserDefaults standardUserDefaults] stringForKey:@"preferEmail"];
    NSString *passwordString =  [[NSUserDefaults standardUserDefaults] stringForKey:@"preferPassword"];
    
    //Check to see if a value has been set for userEmail and password
    if(emailString != nil && passwordString != nil){
            //username is the id for username field in Login form
        NSString*  jScriptString1 = [NSString  stringWithFormat:@"document.getElementsByName('email')[0].value='%@'", emailString];
            //here password is the id for password field in Login Form
        NSString*  jScriptString2 = [NSString stringWithFormat:@"document.getElementsByName('password')[0].value='%@'", passwordString];
            //Call The Javascript for entring these Credential in login Form
        [myWebView stringByEvaluatingJavaScriptFromString:jScriptString1];
        [myWebView stringByEvaluatingJavaScriptFromString:jScriptString2];
        
        //Submit the form automatically 'login_form' is the id name of LoginForm
        [myWebView stringByEvaluatingJavaScriptFromString:@"document.forms['frm_login_form'].submit();"];
    }
}

@end
