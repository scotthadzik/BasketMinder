//
//  SettingsViewController.m
//  BasketMinder
//
//  Created by Scott Hadzik on 12/27/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "SettingsViewController.h"
#import "User.h"

@interface SettingsViewController () <UITextFieldDelegate, NSURLConnectionDelegate>

@end

@implementation SettingsViewController{
    NSString *_alert;
}

@synthesize emailField, passwordField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
    //prefill text field with users information
    self.emailField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"preferEmail"];
    self.passwordField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"preferPassword"];
    self.detailLabel.text = _alert;
    
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
    else{
        [self performSegueWithIdentifier:@"ShowLocations" sender:self];
    }
}

//- (void)textFieldDidEndEditing:(UIText


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(theTextField==self.emailField){
        [self.passwordField becomeFirstResponder];
    }
    if(theTextField==self.passwordField){
        [theTextField resignFirstResponder];
    }
    return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        NSLog(@"init SettingsViewController");
        _alert = @"None";
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Pick2ndAlert"]) {
        SecAlertViewController *secAlertViewController = segue.destinationViewController;
        secAlertViewController.delegate = self;
        secAlertViewController.alert = _alert;
    }
    if ([segue.identifier isEqualToString:@"Pick1stAlert"]) {
        SecAlertViewController *secAlertViewController = segue.destinationViewController;
        secAlertViewController.delegate = self;
        secAlertViewController.alert = _alert;
    }
    
}
- (void)secAlertViewController:(SecAlertViewController *)controller didSelectAlert:(NSString *)alert
{
    _alert = alert;
    self.detailLabel.text = _alert;
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)firstAlertViewController:(FirstAlertViewController *)controller didSelectAlert:(NSString *)alert
{
    _alert = alert;
    self.firstDetailLabel.text = _alert;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
