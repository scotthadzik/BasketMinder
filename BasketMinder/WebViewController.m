//
//  WebViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/23/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "WebViewController.h"
#import <EventKit/EventKit.h>
#import "ConfirmationViewController.h"
#import "SettingsViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController{
    NSDate *timeAppResignedActive; //for webview refresh
    NSDate *timeAppBecameActive;
}

@synthesize myWebView;

@synthesize confirmationNumber,navigationToolBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
    //--------------webView  start -----------------//
    self.myWebView.delegate = self;//allows for call of webViewDidFinishLoad
    NSString *urlAddress = @"http://contributions4.bountifulbaskets.org";
    //NSString *urlAddress = @"http://hadzik.dyndns.org/bb/livepurchase/1.htm";
    [self displayWebView:urlAddress];
    
    //--------------webView  end -----------------//
    
    //for refreshing the webview if the user leaves the app for more than 24 hours
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheWebview) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeLeftActive) name:UIApplicationWillResignActiveNotification object:nil];
    
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.tabBarController.tabBar setHidden:NO];
    BOOL initailSetup = [[NSUserDefaults standardUserDefaults] boolForKey:@"initialSetup"];
    if (!initailSetup) {
        UIViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

//see when the app left active
-(void)timeLeftActive{
    timeAppResignedActive = [NSDate date];
}

//see when the app became active
- (void)refreshTheWebview{
    timeAppBecameActive = [NSDate date];
    NSTimeInterval timeDifferenceBetweenDates = [timeAppResignedActive timeIntervalSinceDate:timeAppBecameActive];
    NSInteger timeAway = timeDifferenceBetweenDates;
    if (timeAway < -86400 ) {  //refresh the webview when inactive for more than 24 hours
        NSString *urlAddress = @"http://hadzik.dyndns.org/bb/livepurchase/1.htm";
        [self displayWebView:urlAddress];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    //show indicator while loading website
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [self sendLogin]; //call the login for the first load of the site
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *error = NULL;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"Contribution confirmation number: \\d{10}" options:NSRegularExpressionCaseInsensitive error:&error];
    //string of html page
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSString *matchDate;
    //NSString *confirmationNumber;
    NSString *month,*day,*year,*time;
    //count the number of times key found on page
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    
    NSArray *results = [regex matchesInString:htmlString options: 0 range:NSMakeRange(0, [htmlString length])];

    //Check for the reciept page showing
    if(numberOfMatches > 0){
        for (NSTextCheckingResult *ntcr in results) {
            confirmationNumber = [htmlString substringWithRange:ntcr.range];
        }
        [[NSUserDefaults standardUserDefaults] setObject:confirmationNumber forKey:@"confirmationNumber"];
        //------------------------find the date of pickup---------------------------
        matchDate = [self regexTheString:htmlString pattern:@"pickup \\w{1,20}, (\\w{1,10}) (\\d{1,2}), (\\d\\d\\d\\d), (\\d{1,2}:\\d\\d)"];
        
        //----------find the year day month and time from the date matched----------
        year = [self regexTheString:matchDate pattern:@"\\d\\d\\d\\d"];
        day = [self regexTheString:matchDate pattern:@" \\d{1,2}, "];
        month = [self regexTheString:matchDate pattern:@", \\w{1,10} "];
        time = [self regexTheString:matchDate pattern:@"\\d{1,2}:\\d\\d"];
        
        //----------------------get the detail time for am or pm--------------------------------/
        NSString *detailURL = [self regexTheString:htmlString pattern:@"href=.{1,200}location details"];
        //trim URL
        detailURL = [detailURL stringByReplacingOccurrencesOfString:@"\">location details" withString:@""];
        detailURL = [detailURL stringByReplacingOccurrencesOfString:@"href=\"" withString:@""];
        detailURL = [detailURL stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
        //go to URL
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:detailURL];
        NSString *webData= [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
        NSString *amORpm = [self regexTheString:webData pattern:@"Pickup Time:</span>\\d{1,2}:\\d\\d \\w{1,2}"];
        amORpm = [amORpm substringFromIndex:amORpm.length - 2];

        //-------------------trim the day and month-----------------------
        day = [day stringByReplacingOccurrencesOfString:@" " withString:@""];//delete spaces and ,
        day = [day stringByReplacingOccurrencesOfString:@"," withString:@""];
        month = [month stringByReplacingOccurrencesOfString:@" " withString:@""]; //delete spaces and ,
        month = [month stringByReplacingOccurrencesOfString:@"," withString:@""];
        month = [month substringToIndex:3]; //only use the first 3 letters of month

        //-------------------setup day string-----------------------------
        NSString *dateString = month;
        dateString = [dateString stringByAppendingString:@"-"];
        dateString = [dateString stringByAppendingString:day];
        dateString = [dateString stringByAppendingString:@"-"];
        dateString = [dateString stringByAppendingString:year];
        dateString = [dateString stringByAppendingString:@"-"];
        dateString = [dateString stringByAppendingString:time];
        dateString = [dateString stringByAppendingString:@" "];
        dateString = [dateString stringByAppendingString:amORpm];
        [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"pickupDate"];
        
        //------------------convert string to date------------------------
        NSDateFormatter *longDate = [[NSDateFormatter alloc] init];
        [longDate setDateFormat:@"MMM-dd-yyyy-hh:mm a"];
        NSDate *pickupDate = [longDate dateFromString:dateString];
        
        //------------------find location address-------------------------
        //get location detail code
        NSString *locationDetail = [self regexTheString:htmlString pattern:@";details=.{1,20}&"];
        locationDetail = [locationDetail stringByReplacingOccurrencesOfString:@";" withString:@"?"];
        locationDetail = [locationDetail stringByAppendingString:@"query=location_address"];
        
        //-----------------go to address site to get address--------------
        //get street address
        NSString *addressURL = @"http://www.tankjig.com/locationinfo.php";
        addressURL = [addressURL stringByAppendingString:locationDetail];
        NSURL *urlForAddress = [NSURL URLWithString:addressURL];
        NSString *addressDetail = [NSString stringWithContentsOfURL:urlForAddress encoding:NSASCIIStringEncoding error:&error];
        addressDetail = [[addressDetail componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "]; //trim off new line
        //get city
        addressURL = [addressURL stringByReplacingOccurrencesOfString:@"location_address" withString:@"city"];
        urlForAddress = [NSURL URLWithString:addressURL];
        NSString *cityDetail = [NSString stringWithContentsOfURL:urlForAddress encoding:NSASCIIStringEncoding error:&error];
        addressDetail = [addressDetail stringByAppendingString:cityDetail];
        addressDetail = [[addressDetail componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@", "]; //trim off new line
        //get state
        addressURL = [addressURL stringByReplacingOccurrencesOfString:@"city" withString:@"state"];
        urlForAddress = [NSURL URLWithString:addressURL];
        NSString *stateDetail = [NSString stringWithContentsOfURL:urlForAddress encoding:NSASCIIStringEncoding error:&error];
        addressDetail = [addressDetail stringByAppendingString:stateDetail];
        
        //get location name
        addressURL = [addressURL stringByReplacingOccurrencesOfString:@"state" withString:@"location_name"];
        urlForAddress = [NSURL URLWithString:addressURL];
        NSString *nameDetail = [NSString stringWithContentsOfURL:urlForAddress encoding:NSASCIIStringEncoding error:&error];
        nameDetail = [[nameDetail componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "]; //trim off new line
        
        //-------------------store event----------------------------------
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            NSString *setEventAlert = [[NSUserDefaults standardUserDefaults] stringForKey:@"setAlertEvent"];
            
            if (!granted || [setEventAlert isEqualToString:@"no"]) { //check for popu permission granted and setting view permissions granted
                return;
            }
            NSString *titleString = @"Basket Pickup at ";
            titleString = [titleString stringByAppendingString:nameDetail];
            EKEvent *event = [EKEvent eventWithEventStore:store];
            event.title = titleString;
            
            event.startDate = pickupDate; //day of pickup
            event.location = addressDetail;//address of pickup
            event.endDate = [event.startDate dateByAddingTimeInterval:60*20];  //20 minute window
            
            NSMutableArray *alarmsArray = [[NSMutableArray alloc] init];
            
            //1st Alarm
            NSString *alertTime = [[NSUserDefaults standardUserDefaults] stringForKey:@"1stAlert"];
            NSTimeInterval alarmTimeInMinutes = [self calcAlarmTime:alertTime]; //first Alert Time
            if (alarmTimeInMinutes != 1) { //if the alarm was set to anything but None send alarm to array
                EKAlarm *alarm1 = [EKAlarm alarmWithRelativeOffset:alarmTimeInMinutes];
                [alarmsArray addObject:alarm1];
            }
            //2nd Alarm
            alertTime = [[NSUserDefaults standardUserDefaults] stringForKey:@"2ndAlert"];
            alarmTimeInMinutes = [self calcAlarmTime:alertTime]; //first Alert Time
            if (alarmTimeInMinutes != 1) {//if the alarm was set to anything but None send alarm to array
                EKAlarm *alarm2 = [EKAlarm alarmWithRelativeOffset:alarmTimeInMinutes]; // 1 Day
                [alarmsArray addObject:alarm2];
            }

            event.alarms = alarmsArray;
                
            [event setCalendar:[store defaultCalendarForNewEvents]];
            NSError *err = nil;
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            //NSString *savedEventId = event.eventIdentifier;  //this is so you can access this event later
        }];
    }    
}

#pragma mark - alert time function
- (NSTimeInterval)calcAlarmTime:(NSString *) alarmTime{
    
    NSArray *_alerts = @[@"None",
                         @"At time of event",
                         @"5 minutes before",
                         @"15 minutes before",
                         @"30 minutes before",
                         @"1 hour before",
                         @"2 hours before",
                         @"1 day before",
                         @"2 days before",
                         @"1 week before"];
    
    NSTimeInterval returnedTime;
    int matchingMinutes = 0;
    for (int i = 0; i<_alerts.count; i++) {
        if ([alarmTime isEqualToString:_alerts[i]]){
            matchingMinutes = i;
        }
    };
    if (matchingMinutes == 0) {
        return 1;               //None
    }
    switch (matchingMinutes) {
       
        case 1:
            returnedTime = 0; //time in seconds before event
            break;
        case 2:
            returnedTime = -300;//5 minutes before
            break;
        case 3:
            returnedTime = -900;//15 minutes before
            break;
        case 4:
            returnedTime = -1800;//30 minutes before
            break;
        case 5:
            returnedTime = -3600;//1 hour before
            break;
        case 6:
            returnedTime = -7200;//2 hours before
            break;
        case 7:
            returnedTime = -86400;//1 day before
            break;
        case 8:
            returnedTime = -172800;//2 days before
            break;
        case 9:
            returnedTime = -604800;//1 week before
            break;
        default:
            returnedTime = 1;
            break;
    }
    
    return returnedTime;
}
#pragma mark - regex function

- (NSString *)regexTheString:(NSString*)string pattern:(NSString*)pattern{
    NSString *returnString;
     NSError *error = NULL;
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *results = [regex matchesInString:string options: 0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *ntcr in results) {
        returnString = [string substringWithRange:ntcr.range];
    }
    
    return returnString;
}
#pragma mark - webview functions

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

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}
@end
