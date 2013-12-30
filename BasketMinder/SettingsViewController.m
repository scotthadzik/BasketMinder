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
    NSString *_email;
    NSString *_password;
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
    
    //dismiss keyboard
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    doneToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPassword)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithPassword)],
                           nil];
    [doneToolbar sizeToFit];
    passwordField.inputAccessoryView = doneToolbar;
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

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(theTextField==self.emailField){
        [self.passwordField becomeFirstResponder];
    }
    if(theTextField==self.passwordField){
        [theTextField resignFirstResponder];
    }
    return YES;
}
-(void)cancelPassword{
    [passwordField resignFirstResponder];
    passwordField.text = @"";
}

-(void)doneWithPassword{
    [self textFieldDidEndEditing:passwordField];
    [passwordField resignFirstResponder];
}



-(void) textFieldDidEndEditing:(UITextField *)textField{
    
    if(textField == emailField){
        _email = self.emailField.text;
        _email = [_email lowercaseString];
        [[NSUserDefaults standardUserDefaults] setObject:_email forKey:@"preferEmail"];
    }
    if(textField == passwordField){
        _password = self.passwordField.text;
        _password = [_password lowercaseString];
        [[NSUserDefaults standardUserDefaults] setObject:_password forKey:@"preferPassword"];
    }
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
