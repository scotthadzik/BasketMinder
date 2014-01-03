//
//  LoginViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 1/2/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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


@end






