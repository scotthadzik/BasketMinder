//
//  BMSignUpViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/20/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "BMSignUpViewController.h"
#import <Parse/Parse.h>

@interface BMSignUpViewController () <UITextFieldDelegate>

@end

@implementation BMSignUpViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}





- (IBAction)signUp:(id)sender {
    
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //convert the textfield into a string and trim white space
    email = [email lowercaseString];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //convert the textfield into a string
    
    
    if([email length] == 0 || [password length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Make sure you enter an E-mail and Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        
    }
    else{
        PFUser *newUser = [PFUser user];
        newUser.username = email;
        newUser.email = email;
        newUser.password = password;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message: [error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
            }
            else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        
        
    }

}

@end
