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






