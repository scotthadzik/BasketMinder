//
//  LoginViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 1/2/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import "LoginViewController.h"
#import "globals.h"

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

-(NSUInteger)checkForValidLogin:(NSString *) email{
    
    
    NSString *post =[[NSString alloc] initWithFormat:@"c=login&m=__login&email=%@&password=password&login=Login", email];
    
    NSURL *url=[NSURL URLWithString:@"http://contributions3.bountifulbaskets.org/index.php?"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
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
   // NSLog(@"response %@", response);
   // NSLog(@"responseData %@", responseData);
    
    error = NULL;
    NSString *loggedInIndication = @"<h2>My Account</h2>[^/]+?Welcome";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:loggedInIndication options:NSRegularExpressionCaseInsensitive error:&error];
    //string of html page
    
    //count the number of times key found on page
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:responseData options:0 range:NSMakeRange(0, [responseData length])];
    
    return numberOfMatches;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    BOOL initialSetup = [[NSUserDefaults standardUserDefaults] boolForKey:@"initialSetup"];
    if (initialSetup) {//check to see if this is the first time the user has opened the app
        [self gotoLoginViewController];
    }
}

- (IBAction)login:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"preferEmail"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"preferPassword"];
    
    NSUInteger validLogin = [self checkForValidLogin:username];
    
    if (validLogin > 0) {
        NSLog(@"valid Login");
    }
    else{
        NSLog(@"invalid Login");
    }
    
    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter a username and password!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else{
        [self gotoLoginViewController];//valid login go to tutorial page
    }
    
}
-(void)gotoLoginViewController{
    UIViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageRootViewController"];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

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






