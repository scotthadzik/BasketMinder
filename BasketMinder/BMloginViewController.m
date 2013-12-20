//
//  BMloginViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/20/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "BMloginViewController.h"

@interface BMloginViewController () <UITextFieldDelegate>

@end

@implementation BMloginViewController

@synthesize userEmail;
@synthesize userPassword;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    userEmail.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"preferEmail"];
    userPassword.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"preferPassword"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//dismiss the keyboard when touched outside of text field
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

//Change the value of the prefered email stored in user defaults
- (IBAction)changeValue:(id)sender {
    
    NSString *Email = userEmail.text; //convert the textfield into a string
    
    //adds the string data to the defaults with key preferEmail
    [[NSUserDefaults standardUserDefaults] setObject:Email forKey:@"preferEmail"];
    
}
//Change the value of the prefered passsword stored in user defaults
- (IBAction)changePassword:(id)sender {
    NSString *password = userPassword.text; //convert the textfield into a string
    
    //adds the string data to the defaults with key preferPassword
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"preferPassword"];
}



@end
