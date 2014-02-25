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
#import "UICKeyChainStore.h"
#import "BMAppDelegate.h"
#import "UICKeyChainStore.h"

@interface WebViewController ()<UIAlertViewDelegate>

@end

@implementation WebViewController{
    NSDate *timeAppResignedActive; //for webview refresh
    NSDate *timeAppBecameActive;
    NSString *urlAddress;
    
    NSString *matchDate;
    NSString *basketPickupRegex;
    NSString *confirmationNumberRegex;
    NSString *yearRegexPattern;
    NSString *dayRegexPattern;
    NSString *monthRegexPattern;
    NSString *timeRegexPattern;
    NSString *locationDetailPattern;
    NSString *month,*day,*year,*time;
    NSDate *pickupDate;
    NSUInteger count;
}

@synthesize myWebView;

@synthesize confirmationNumber,navigationToolBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self customizeViewController];
    
    //--------------webView  start -----------------//
    self.myWebView.delegate = self;//allows for call of webViewDidFinishLoad
    
    [self checkForTestLogin];//check for tester1234 for test site
    [self displayWebView:urlAddress];//load the url
    
    //--------------webView  end -----------------//
    
    //for refreshing the webview if the user leaves the app for more than 24 hours
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheWebview) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeLeftActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    [self setPatternsForRegex];
    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self customizeViewController];
    BOOL initailSetup = [[NSUserDefaults standardUserDefaults] boolForKey:@"initialSetup"];
    if (!initailSetup) {
        UIViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
    BOOL newLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"newLogin"];
    if(newLogin){
        [self checkForTestLogin];
        [self displayWebView:urlAddress];
    }
}
//used or testing purposes
-(void)checkForTestLogin{
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"preferEmail"];
    if ([email isEqualToString:@"tester1234"]) {
        urlAddress = @"http://hadzik.dyndns.org/bb/livepurchase/1.htm";
    }
    else{
        urlAddress = @"http://contributions.bountifulbaskets.org/";
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
        [self checkForTestLogin];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"newLogin"];//reset the new login bool
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self displayWebView:urlAddress];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    //show indicator while loading website
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

-(void)setPatternsForRegex{
    //patterns for regex
    basketPickupRegex = @"Basket Pickup Week Ending \\w{1,20} \\d{1,2}, \\d\\d\\d\\d, \\d{1,2}:\\d\\d \\w\\w";
    confirmationNumberRegex = @"Contribution confirmation number: \\d{10}";
    yearRegexPattern = @"\\d\\d\\d\\d";
    dayRegexPattern = @" \\d{1,2}, ";
    monthRegexPattern = @"Ending \\w{1,20} ";
    timeRegexPattern = @"\\d{1,2}:\\d\\d \\w\\w";
    locationDetailPattern = @";details=.{1,20}&";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    BOOL validLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"validLogin"];
    BOOL changedLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"newLogin"];
    if (validLogin && changedLogin) {
        [self sendLogin];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"newLogin"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
     //call the login for the first load of the site
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *error = NULL;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:confirmationNumberRegex options:NSRegularExpressionCaseInsensitive error:&error];
    //string of html page
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];

    //count the number of times key found on page
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    
    NSArray *results = [regex matchesInString:htmlString options: 0 range:NSMakeRange(0, [htmlString length])];

    
    //check for checkout webview
    NSString *currentURL = myWebView.request.URL.absoluteString;
    if (!([currentURL rangeOfString:@"checkout" ].location == NSNotFound)){
        [self enterCheckoutData];
    }
    
    //Check for the reciept page showing
    if(numberOfMatches > 0){
        for (NSTextCheckingResult *ntcr in results) {
            confirmationNumber = [htmlString substringWithRange:ntcr.range];
        }
        confirmationNumber = [confirmationNumber stringByReplacingOccurrencesOfString:@"Contribution confirmation number: " withString:@""];
        [[NSUserDefaults standardUserDefaults] setObject:confirmationNumber forKey:@"confirmationNumber"];
        
        //------------------------find the date of pickup---------------------------
        matchDate = [self regexTheString:htmlString pattern:basketPickupRegex];
        pickupDate = [self getEventDate];
        
        //------------------find location address-------------------------
        //get location detail code
        NSString *locationDetail = [self regexTheString:htmlString pattern:locationDetailPattern];
        locationDetail = [locationDetail stringByReplacingOccurrencesOfString:@";" withString:@"?"];
        locationDetail = [locationDetail stringByAppendingString:@"query=location_address"];
        
        //-----------------go to address site to get address--------------
        //get street address
        NSString *addressURL = @"http://www.tankjig.com/locationinfo.php";
        addressURL = [addressURL stringByAppendingString:locationDetail];
        NSURL *urlForAddress = [NSURL URLWithString:addressURL];
        NSString *addressDetail = [NSString stringWithContentsOfURL:urlForAddress encoding:NSASCIIStringEncoding error:&error];
        addressDetail = [self trimTheNewLine:addressDetail replace:@" "];
        [[NSUserDefaults standardUserDefaults] setObject:addressDetail forKey:@"pickupAddress"];
        
        //get city
        addressURL = [addressURL stringByReplacingOccurrencesOfString:@"location_address" withString:@"city"];
        urlForAddress = [NSURL URLWithString:addressURL];
        NSString *cityDetail = [NSString stringWithContentsOfURL:urlForAddress encoding:NSASCIIStringEncoding error:&error];
        cityDetail = [self trimTheNewLine:cityDetail replace:@", "];
        addressDetail = [addressDetail stringByAppendingString:cityDetail];
        [[NSUserDefaults standardUserDefaults] setObject:cityDetail forKey:@"pickupCity"];
        
        //get state
        addressURL = [addressURL stringByReplacingOccurrencesOfString:@"city" withString:@"state"];
        urlForAddress = [NSURL URLWithString:addressURL];
        NSString *stateDetail = [NSString stringWithContentsOfURL:urlForAddress encoding:NSASCIIStringEncoding error:&error];
         stateDetail = [self trimTheNewLine:stateDetail replace:@" "];
        addressDetail = [addressDetail stringByAppendingString:stateDetail];
        [[NSUserDefaults standardUserDefaults] setObject:stateDetail forKey:@"pickupState"];
        
        //get location name
        addressURL = [addressURL stringByReplacingOccurrencesOfString:@"state" withString:@"location_name"];
        urlForAddress = [NSURL URLWithString:addressURL];
        NSString *nameDetail = [NSString stringWithContentsOfURL:urlForAddress encoding:NSASCIIStringEncoding error:&error];
        nameDetail = [[nameDetail componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "]; //trim off new line
        [[NSUserDefaults standardUserDefaults] setObject:nameDetail forKey:@"pickupName"];
        
        //-------------------store event----------------------------------
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            NSString *setEventAlert = [[NSUserDefaults standardUserDefaults] stringForKey:@"setAlertEvent"];
            
            if (!granted || [setEventAlert isEqualToString:@"no"]) { //check for popu permission granted and setting view permissions granted
                return;
            }
            
            //alert the user an event has been created
            BOOL dontShowAlert = [[NSUserDefaults standardUserDefaults] boolForKey:@"turnOffAlertViewNotify"];
            if (!dontShowAlert){
                [self performSelectorOnMainThread:@selector(alertSetNotify) withObject:nil waitUntilDone:YES];
            }
            //set up the event title
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
        
        //Volunteer Reminder
        [self volunteerCounter];
    }    
}
#pragma -mark Alert for Volunteer Reminder
-(void)volunteerCounter{
    count = [[NSUserDefaults standardUserDefaults] integerForKey:@"volunteerCount"];
    ++count;
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"volunteerCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (count > 7){
        [self alertForVolunteer];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"volunteerCount"];
    }
}
-(void)alertForVolunteer{
    
    NSString *message = @"This is a volunteer organization, have you considered volunteering at your local sight";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Volunteer"
                                                    message:message
                                                       delegate:self cancelButtonTitle:@"Thanks for the Reminder" otherButtonTitles:@"Learn More",nil];
    [alertView setTag:2];
    [alertView show];
}


#pragma -mark Alert for Confirmation Number Set
-(void)alertSetNotify{
    
    NSString *stringFromDate = [[NSUserDefaults standardUserDefaults] stringForKey:@"pickupDate"];
    
    NSString *message = @"A pickup event has been sent to your calendar for ";
    message = [message stringByAppendingString:stringFromDate];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:@"Your confirmation number "];
    message = [message stringByAppendingString:confirmationNumber];
    message = [message stringByAppendingString:@" has been saved in the confirmation tab found below"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Event and Confirmation"
                                                        message:message
                                                       delegate:self cancelButtonTitle:@"Don't Show This Again" otherButtonTitles:@"OK",nil];
    [alertView setTag:1];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    
    if ([alertView tag] == 1){//confirmation alert
        if (buttonIndex ==  0){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"turnOffAlertViewNotify"]; //the login information is invalid do not log into website automatically
        }
    }
    if ([alertView tag] == 2){  //volunteer alert
        if (buttonIndex == 1){
            UIViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewParticipantViewController"]; //tutorial page
            [self presentViewController:loginViewController animated:YES completion:nil];
        }
    }
}

- (NSString *)trimTheNewLine:(NSString*)string replace:(NSString*)replace{
    NSString *returnString = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:replace]; //trim off new line
    
    return returnString;
    
}

#pragma mark -enter checkout data
-(void)enterCheckoutData{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    //information for checkout
    [myWebView stringByEvaluatingJavaScriptFromString:[NSString  stringWithFormat:@"document.getElementsByName('nameoncard')[0].value='%@'", [store stringForKey:@"nameOnCard"]]];
    [myWebView stringByEvaluatingJavaScriptFromString:[NSString  stringWithFormat:@"document.getElementsByName('cardnumber')[0].value='%@'", [store stringForKey:@"cardNumber"]]];
    [myWebView stringByEvaluatingJavaScriptFromString:[NSString  stringWithFormat:@"document.getElementsByName('address')[0].value='%@'", [store stringForKey:@"billingAddress"]]];
    [myWebView stringByEvaluatingJavaScriptFromString:[NSString  stringWithFormat:@"document.getElementsByName('city')[0].value='%@'", [store stringForKey:@"billingCity"]]];
    [myWebView stringByEvaluatingJavaScriptFromString:[NSString  stringWithFormat:@"document.getElementsByName('state')[0].value='%@'", [store stringForKey:@"billingState"]]];
    [myWebView stringByEvaluatingJavaScriptFromString:[NSString  stringWithFormat:@"document.getElementsByName('postalcode')[0].value='%@'", [store stringForKey:@"billingZip"]]];
}

#pragma mark -get web data
-(NSDate *)getEventDate{
    //----------find the year day month and time from the date matched----------
    year = [self regexTheString:matchDate pattern:yearRegexPattern];
    day = [self regexTheString:matchDate pattern:dayRegexPattern];
    month = [self regexTheString:matchDate pattern:monthRegexPattern];
    time = [self regexTheString:matchDate pattern:timeRegexPattern];
    
    //-------------------trim the day and month-----------------------
    day = [day stringByReplacingOccurrencesOfString:@" " withString:@""];//delete spaces and ,
    day = [day stringByReplacingOccurrencesOfString:@"," withString:@""];
    month = [month stringByReplacingOccurrencesOfString:@"Ending " withString:@""];
    month = [month stringByReplacingOccurrencesOfString:@" " withString:@""]; //delete spaces and ,
    month = [month substringToIndex:3]; //only use the first 3 letters of month
    
    //-------------------setup day string-----------------------------
    NSString *dateString = month;
    dateString = [dateString stringByAppendingString:@" "];
    dateString = [dateString stringByAppendingString:day];
    dateString = [dateString stringByAppendingString:@", "];
    dateString = [dateString stringByAppendingString:year];
    dateString = [dateString stringByAppendingString:@" "];
    dateString = [dateString stringByAppendingString:time];
    [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"pickupDate"];
    
    //------------------convert string to date------------------------
    NSDateFormatter *longDate = [[NSDateFormatter alloc] init];
    [longDate setDateFormat:@"MMM dd, yyyy hh:mm a"];
    NSDate *pickupDateReturn = [longDate dateFromString:dateString];
    return pickupDateReturn;
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
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];

    NSString *emailString   =  [[NSUserDefaults standardUserDefaults] stringForKey:@"preferEmail"];
    BOOL validLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"validLogin"];
    
    //Check to see if a value has been set for userEmail and password
    if(validLogin){
            //username is the id for username field in Login form
        NSString*  jScriptString1 = [NSString  stringWithFormat:@"document.getElementsByName('email')[0].value='%@'", emailString];
            //here password is the id for password field in Login Form
        NSString*  jScriptString2 = [NSString stringWithFormat:@"document.getElementsByName('password')[0].value='%@'", [store stringForKey:@"password"]];
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
-(void)customizeViewController{
   
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setTranslucent:NO];
    self.tabBarController.delegate = self;
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    tabBar.translucent = NO;
    
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
