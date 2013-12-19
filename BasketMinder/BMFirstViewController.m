//
//  BMFirstViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/18/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "BMFirstViewController.h"

@interface BMFirstViewController ()

@end

@implementation BMFirstViewController

@synthesize myWebView; //= _myWebView;
@synthesize isLoggedIn = _isLoggedIn;




- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //--------------webView  start -----------------//
	
    self.myWebView.delegate = self;//allows for call of webViewDidFinishLoad
    
    NSURL *myURL = [NSURL URLWithString:@"http://contributions4.bountifulbaskets.org"]; //start at this website
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    
    [self.myWebView loadRequest:myRequest]; //load the webview
    
    myWebView.scalesPageToFit = YES;
    //--------------webView  end -----------------//
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   [self sendLogin]; //call the login for the first load of the site
}

//This will run each time the view appears in case of new login
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self sendLogin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _isLoggedIn=TRUE;
}

@end
