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
    NSString *_1stAlert;
    NSString *_2ndAlert;
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
    
    //Prefill the 1st and second default times if set by user
    NSString *firstAlertDefault = [[NSUserDefaults standardUserDefaults] stringForKey:@"1stAlert"];
    NSString *secAlertDefault = [[NSUserDefaults standardUserDefaults] stringForKey:@"2ndAlert"];
    [self checkForDefaultSet:self.firstDetailLabel setLabel:firstAlertDefault alertDefault:_1stAlert];
    [self checkForDefaultSet:self.secDetailLabel setLabel:secAlertDefault alertDefault:_2ndAlert];

    //For dismiss keyboard addded toolbar
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
#pragma mark - Email and Password

//for moving to the next textfield when return pressed on keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(theTextField==self.emailField){
        [self.passwordField becomeFirstResponder];
    }
    if(theTextField==self.passwordField){
        [theTextField resignFirstResponder];
    }
    return YES;
}
//for password field done button added to toolbar
-(void)cancelPassword{
    [passwordField resignFirstResponder];
    passwordField.text = @"";
}
-(void)doneWithPassword{
    [self textFieldDidEndEditing:passwordField];
    [passwordField resignFirstResponder];
}
//for saving the data to NSUserDefaults entered into the textFields
-(void) textFieldDidEndEditing:(UITextField *)textField{
    
    if(textField == emailField){
        _email = self.emailField.text;
        _email = [_email lowercaseString];
        [[NSUserDefaults standardUserDefaults] setObject:_email forKey:@"preferEmail"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if(textField == passwordField){
        _password = self.passwordField.text;
        [[NSUserDefaults standardUserDefaults] setObject:_password forKey:@"preferPassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
#pragma mark - First and Second Alert Settings

- (void)checkForDefaultSet:(UILabel*)label setLabel:(NSString*)string alertDefault:(NSString*)alert{
    
    if(string != NULL){
        label.text = string;
    }
    else{
        label.text = alert;
    }
}
//this sets the checkmark in the first and sec detail viewcontrollers
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        
        NSString *firstAlertDefault = [[NSUserDefaults standardUserDefaults] stringForKey:@"1stAlert"];
        NSString *secAlertDefault = [[NSUserDefaults standardUserDefaults] stringForKey:@"2ndAlert"];
        //check for defaults set
        if (firstAlertDefault == NULL){
            _1stAlert = @"15 minutes before";
            [[NSUserDefaults standardUserDefaults] setObject:_1stAlert forKey:@"1stAlert"];//set this as initial default
        }
        else{
            _1stAlert = firstAlertDefault;
        }
        if (secAlertDefault == NULL){
            _2ndAlert = @"None";
            [[NSUserDefaults standardUserDefaults] setObject:_2ndAlert forKey:@"2ndAlert"];//set this as initial default
        }
        else{
            _2ndAlert = secAlertDefault;
        }
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"Pick1stAlert"]) {
        FirstAlertViewController *firstAlertViewController = segue.destinationViewController;
        firstAlertViewController.delegate = self;
        firstAlertViewController.alert = _1stAlert;
    }
    if ([segue.identifier isEqualToString:@"Pick2ndAlert"]) {
        SecAlertViewController *secAlertViewController = segue.destinationViewController;
        secAlertViewController.delegate = self;
        secAlertViewController.alert = _2ndAlert;
    }
    
}

- (void)firstAlertViewController:(FirstAlertViewController *)controller didSelectAlert:(NSString *)alert
{
    _1stAlert = alert;
    self.firstDetailLabel.text = _1stAlert;
    [[NSUserDefaults standardUserDefaults] setObject:_1stAlert forKey:@"1stAlert"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)secAlertViewController:(SecAlertViewController *)controller didSelectAlert:(NSString *)alert
{
    _2ndAlert = alert;
    self.secDetailLabel.text = _2ndAlert;
    [[NSUserDefaults standardUserDefaults] setObject:_2ndAlert forKey:@"2ndAlert"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
