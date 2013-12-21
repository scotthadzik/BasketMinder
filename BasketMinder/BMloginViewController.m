//
//  BMloginViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/20/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "BMloginViewController.h"
#import "BMWebsiteViewController.h"
#import <Parse/Parse.h>

@interface BMloginViewController () 

@end

@implementation BMloginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    
     PFUser *currentUser = [PFUser currentUser];
    _emailField.text = currentUser.email;
    _passwordField.text = currentUser.password;
}

//dismiss the keyboard when touched outside of text field
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)loginButton:(id)sender {
    
    
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //convert the textfield into a string and trim white space
    email = [email lowercaseString];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //convert the textfield into a string
    
    //login validation
    
//   // NSString *post = [NSString stringWithFormat:@"&UserName=%@&Password=%@",email,password];
//    NSString *post = [NSString stringWithFormat:@"&UserName=%@&Password=%@",email,password];
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://contributions4.bountifulbaskets.org"]]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
//    [request setHTTPBody:postData];
//    
//    NSHTTPURLResponse* urlResponse = nil;
//    NSError *error = [[NSError alloc] init];
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
//    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"Response Code: %d", [urlResponse statusCode]);
//    
//    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
//    {
//        NSLog(@"Response: %@", result);
//    }
    
    
    
    
    
    if([email length] == 0 || [password length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Make sure you enter an E-mail and Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
    }
    else{
        [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message: [error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
            }
            else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
    
        }];
    }
    
    
}
@end
