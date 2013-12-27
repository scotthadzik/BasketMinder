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
@synthesize backendWebView;
@synthesize confirmationNumber;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //--------------webView  start -----------------//
    
    self.myWebView.delegate = self;//allows for call of webViewDidFinishLoad
    self.backendWebView.delegate = self;
    //NSString *urlAddress = @"http://contributions4.bountifulbaskets.org";
    NSString *urlAddress = @"http://hadzik.dyndns.org/bb/livepurchase/1.htm";
    //http://hadzik.dyndns.org/bb/livepurchase/1.htm
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
        //////NSLog(@"%@",amORpm);
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
        NSString *addressURL = @"http://162.243.202.112/locationinfo.php";
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
        nameDetail = [[nameDetail componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@", "]; //trim off new line
        
    
        //-------------------store event----------------------------------
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) {
                return;
            }
            NSString *titleString = @"Basket Pickup at ";
            titleString = [titleString stringByAppendingString:nameDetail];
            EKEvent *event = [EKEvent eventWithEventStore:store];
            event.title = titleString;
            
            event.startDate = pickupDate; //day of pickup
            event.location = addressDetail;
            
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



@end
