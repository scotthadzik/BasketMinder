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
    
   // NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //convert the textfield into a string and trim white space
   // email = [email lowercaseString];
    //NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //convert the textfield into a string
    NSString *email = @"sgthad@gmail.com";
    NSString *password = @"password";
    
    //login validation
    
       // NSString *post = [NSString stringWithFormat:@"?email=%@&password=%@",email,password];
      //  NSString *post = @"email=sgthad@gmail.com&password=password";//,[self urlEncodeValue:email], [self urlEncodeValue:password];
        NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", [self urlEncodeValue:email], [self urlEncodeValue:password]];
        // NSLog(@"email: %@",email);
       // NSLog(@"password: %@",password);
        NSLog(@"Post: %@",post);
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://contributions1.bountifulbaskets.org"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        NSLog(@"Post Data: %@",postData);
        [request setHTTPBody:postData];
    
    
    
    //+ (void)sendAsynchronousRequest:(NSURLRequest )request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse, //NSData*, NSError*))handler –
    
    
    
        NSHTTPURLResponse* urlResponse = nil;
        NSError *error = [[NSError alloc] init];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"Response Code: %d", [urlResponse statusCode]);
    
       if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
        {
            NSLog(@"Response: %@", result);
        }
    
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

- (NSString *)urlEncodeValue:(NSString *)str
{
    NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8));
    NSLog(@"result : %@", result);
    return result;
}

@end
