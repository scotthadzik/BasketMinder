//
//  LoginViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/23/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

    //prefill text field with users information
    self.emailField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"preferEmail"];
    self.passwordField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"preferPassword"];
   
    if (self.emailField.hasText){
        NSLog(@"current user");
        [self performSegueWithIdentifier:@"ShowWebView" sender:self];
    }
}

//dismiss the keyboard when touched outside of text field
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)loginButton:(id)sender {
    
    User *newUser = [User userWithEmail:self.emailField.text];
    newUser.password = self.passwordField.text;
    
    if(newUser.email.length == 0 || newUser.password.length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Make sure you enter an E-mail and Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
    }
}
@end
