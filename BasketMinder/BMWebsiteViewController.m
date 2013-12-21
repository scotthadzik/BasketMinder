//
//  BMWebsiteViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/20/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "BMWebsiteViewController.h"
#import <Parse/Parse.h>

@interface BMWebsiteViewController ()

@end

@implementation BMWebsiteViewController

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
    
    self.myWebView.scalesPageToFit = YES;
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        
        // here 'login_form' is the id name of LoginForm
    }
    else{
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
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


- (void) sendLogin{
  
    PFUser *currentUser = [PFUser currentUser];
    
    NSString *jScriptString1 = [NSString  stringWithFormat:@"document.getElementsByName('email')[0].value='%@'", currentUser.email];
    
    //username is the id for username field in Login form
    
    NSString *jScriptString2 = [NSString stringWithFormat:@"document.getElementsByName('password')[0].value='%@'", currentUser.password];
    //here password is the id for password field in Login Form
    
    //Call The Javascript for entering these Credential in login Form
    [myWebView stringByEvaluatingJavaScriptFromString:jScriptString1];
    
    [myWebView stringByEvaluatingJavaScriptFromString:jScriptString2];
    
    //Submit the form automatically
    [myWebView stringByEvaluatingJavaScriptFromString:@"document.forms['frm_login_form'].submit();"];
}

- (IBAction)logoutButton:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}


@end
