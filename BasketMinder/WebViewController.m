//
//  WebViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/23/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize myWebView; //= _myWebView;
@synthesize isLoggedIn = _isLoggedIn;




- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //--------------webView  start -----------------//
    
    self.myWebView.delegate = self;//allows for call of webViewDidFinishLoad
    
    NSString *urlAddress = @"http://contributions4.bountifulbaskets.org";
    
    [self displayWebView:urlAddress];
    
    // if (currentUser) {
    
    // here 'login_form' is the id name of LoginForm
    // }
    // else{
   // [self performSegueWithIdentifier:@"showLogin" sender:self];
    // }
    
    //--------------webView  end -----------------//
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[self sendLogin]; //call the login for the first load of the site
}

//This will run each time the view appears in case of new login
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self sendLogin];
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
        
        NSString*  jScriptString1 = [NSString  stringWithFormat:@"document.getElementsByName('email')[0].value='%@'", emailString];
        
        
        //username is the id for username field in Login form
        
        NSString*  jScriptString2 = [NSString stringWithFormat:@"document.getElementsByName('password')[0].value='%@'", passwordString];
        //here password is the id for password field in Login Form
        
        //Call The Javascript for entring these Credential in login Form
        [myWebView stringByEvaluatingJavaScriptFromString:jScriptString1];
        
        [myWebView stringByEvaluatingJavaScriptFromString:jScriptString2];
        
        //Submit the form automatically
        [myWebView stringByEvaluatingJavaScriptFromString:@"document.forms['frm_login_form'].submit();"];
        // here 'login_form' is the id name of LoginForm
    }
}

- (IBAction)settings:(id)sender {
    
    // NSString *urlAddress = @"http://contributions4.bountifulbaskets.org/Logout.html";
    // [self displayWebView:urlAddress];
    // [self.myWebView reload];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"preferEmail"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"preferPassword"];
    
    
    // urlAddress = @"http://contributions4.bountifulbaskets.org";
    //[self displayWebView:urlAddress];
    
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}


@end
