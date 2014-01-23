//
//  LoginViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 1/2/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import "LoginViewController.h"
#import "globals.h"
#import "UICKeyChainStore.h"

@interface LoginViewController ()

@end


@implementation LoginViewController
    

    


@synthesize loginButton;
@synthesize passwordField;
@synthesize usernameField;
@synthesize bbTitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeLoginScreen];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    BOOL initialSetup = [[NSUserDefaults standardUserDefaults] boolForKey:@"initialSetup"];
    if (initialSetup) {//check to see if this is the first time the user has opened the app
        [self gotoLoginViewController];
    }
}

#pragma -mark login validation check
- (IBAction)login:(id)sender {
    //SAVE username and password
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    [store setString:passwordField.text forKey:@"password"];
    [store synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"preferEmail"];
    
    //check for entry of username and password
    if ([username length] == 0 || [passwordField.text length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter a username and password!"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Continue Anyway",nil];
        [alertView show];
    }
    else{ //data has been entered in both fields check for valid login
        NSUInteger validLogin = [self checkForValidLogin:username];
        
        if (validLogin > 0) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"validLogin"]; //The login information is valid login to website
            [self gotoLoginViewController];//valid login go to tutorial page
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"newLogin"];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Login or Password"
                                                                message:@"Use your Bountiful Baskets Login"
                                                               delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:@"Continue Anyway",nil];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"validLogin"];
            [alertView show];
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex ==  1){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"validLogin"]; //the login information is invalid do not log into website automatically
        //clear login information
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"preferEmail"];
        UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
        [store setString:@"" forKey:@"password"];
        [store synchronize];
        [self gotoLoginViewController];
    }
}
-(NSUInteger)checkForValidLogin:(NSString *) email{
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore]; //get password stored value
    //SETUP THE POST
    NSString *post =[[NSString alloc] initWithFormat:@"c=login&m=__login&email=%@&password=%@&login=Login", email, [store stringForKey:@"password"]];
    NSURL *url=[NSURL URLWithString:@"http://contributions3.bountifulbaskets.org/index.php?"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    
    //check for the logged in screen
    error = NULL;
    NSString *loggedInIndication = @"<h2>My Account</h2>[^/]+?Welcome";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:loggedInIndication options:NSRegularExpressionCaseInsensitive error:&error];
    //count the number of times key found on page
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:responseData options:0 range:NSMakeRange(0, [responseData length])];
    //returning a 1 indicates that the logged in screen was found
    
    return numberOfMatches;
}

#pragma -mark go to the tutorial pages
-(void)gotoLoginViewController{
    UIViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageRootViewController"]; //tutorial page
    [self presentViewController:loginViewController animated:YES completion:nil];
}

#pragma -mark customize this view
-(void)customizeLoginScreen{
    globals *sharedData = [globals sharedData];
    
    loginButton.titleLabel.font = [UIFont fontWithName:@"IstokWeb-Regular" size:18];
    bbTitle.font = [UIFont fontWithName:@"IstokWeb-Regular" size:18];
    
    passwordField.layer.cornerRadius = 5;
    passwordField.layer.borderWidth = 1.5;
    passwordField.layer.borderColor = sharedData.redColor.CGColor;
    
    usernameField.layer.cornerRadius = 5;
    usernameField.layer.borderWidth = 1.5;
    usernameField.layer.borderColor = sharedData.redColor.CGColor;
    
    loginButton.layer.cornerRadius = 5;
    loginButton.layer.borderWidth = 1.5;
    loginButton.layer.borderColor = sharedData.redColor.CGColor;
}

@end






