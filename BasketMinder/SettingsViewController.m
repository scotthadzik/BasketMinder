//
//  SettingsViewController.m
//  BasketMinder
//
//  Created by Scott Hadzik on 12/27/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "SettingsViewController.h"
#import "BillingInformationViewController.h"
#import "globals.h"
#import "UICKeyChainStore.h"

@interface SettingsViewController () <UITextFieldDelegate, NSURLConnectionDelegate>

@end

@implementation SettingsViewController{
    NSString *_1stAlert;
    NSString *_email;
    NSString *_password;
    NSString *_loggedIn;
    NSString *_setAlertEvent;
    NSUInteger validLogin;
}

@synthesize emailField, passwordField, setEventSwitch;
@synthesize firstAlertCell;
@synthesize firstAlertTimeLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeView];
    
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
    //get the stored password
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    
    //prefill text field with users information
    self.emailField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"preferEmail"];
    self.passwordField.text = [store stringForKey:@"password"];
    
    //preselect the Set Event Alert Switch
    NSString *setEventAlertSwitch = [[NSUserDefaults standardUserDefaults] stringForKey:@"setAlertEvent"];
    if ([setEventAlertSwitch isEqualToString:@"no"]){
        [setEventSwitch setOn:NO];
        firstAlertCell.detailTextLabel.text = @"";
        [self changeCellColor:YES];
    }else{
        [self changeCellColor:NO];
        //Prefill the 1st and second default times if set by user
        NSString *firstAlertDefault = [[NSUserDefaults standardUserDefaults] stringForKey:@"1stAlert"];
        [self checkForDefaultSet:firstAlertCell.detailTextLabel setLabel:firstAlertDefault alertDefault:_1stAlert];
    }
    
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
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self customizeView];
    if(setEventSwitch.on){
        [self changeCellColor:NO];
    }else{
        [self changeCellColor:YES];
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
    //[self textFieldDidEndEditing:passwordField];
    [passwordField resignFirstResponder];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"validLogin"];
    [store setString:@"" forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"preferEmail"];
    [store synchronize];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//for saving the data to NSUserDefaults entered into the textFields
-(void) textFieldDidEndEditing:(UITextField *)textField{
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
   // _email = self.emailField.text;
   // _email = [_email lowercaseString];
    [[NSUserDefaults standardUserDefaults] setObject:self.emailField.text forKey:@"preferEmail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(textField == emailField){
        //clear the password field
        passwordField.text = @"";
    }
    if(textField == passwordField){
        [store setString:passwordField.text forKey:@"password"];
        [store synchronize];
        if(self.passwordField.text.length != 0 && self.emailField.text.length != 0){
            NSLog(@"checking for valid Login valid login #, %lu", (unsigned long)validLogin);
            validLogin = [self checkForValidLogin:self.emailField.text];
            NSLog(validLogin ? @"Yes": @"No");
            if (validLogin > 0) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"validLogin"]; //The login information is valid login to website
                NSLog(@"valid Login");
            }
            else{
                NSLog(@"invalid Login");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Login or Password"
                                                                    message:@"Use your Bountiful Baskets Login"
                                                                   delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:@"Continue Anyway",nil];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"validLogin"];
                [alertView show];
            }
            
        }
        else{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"validLogin"];
        }
    }
    validLogin = 0;
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"newLogin"];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex ==  1){
        NSLog(@"Don't Save");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"validLogin"]; //the login information is invalid do not log into website automatically
        //clear login information
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"preferEmail"];
        UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
        [store setString:@"" forKey:@"password"];
        [store synchronize];
    }
}

-(NSUInteger)checkForValidLogin:(NSString *) email{
   
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];

    
    NSString *post =[[NSString alloc] initWithFormat:@"c=login&m=__login&email=%@&password=%@&login=Login", email, [store stringForKey:@"password"]];
    NSLog(@"login %@", post);
    
    NSURL *url=[NSURL URLWithString:@"http://contributions3.bountifulbaskets.org/index.php?"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
   // NSLog(@"responseData %@", responseData);
    error = NULL;
    NSString *loggedInIndication = @"<h2>My Account</h2>[^/]+?Welcome";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:loggedInIndication options:NSRegularExpressionCaseInsensitive error:&error];
    //string of html page
    
    //count the number of times key found on page
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:responseData options:0 range:NSMakeRange(0, [responseData length])];
    NSLog(@"numberOfMatches %lu", (unsigned long)numberOfMatches);
    return numberOfMatches;
}

#pragma mark - First and Second Alert Settings
//switch Event alert
- (IBAction)setEventSwitch:(id)sender{
    UISwitch *eventSwitch = (UISwitch *) sender;
    if(eventSwitch.on){
        _setAlertEvent = @"yes";
        [self changeCellColor:NO];
        firstAlertCell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"1stAlert"];
        [self.tableView reloadData];
    }
    else{
        _setAlertEvent = @"no";
        firstAlertCell.detailTextLabel.text = @"";
        [self changeCellColor:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"None" forKey:@"1stAlert"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:_setAlertEvent forKey:@"setAlertEvent"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)changeCellColor:(BOOL) grey{
    
    globals *sharedData = [globals sharedData];
    
    firstAlertTimeLabel.backgroundColor = [UIColor clearColor];
    firstAlertCell.contentView.backgroundColor = [UIColor clearColor];
    firstAlertTimeLabel.textColor = [UIColor clearColor];
    firstAlertCell.accessoryView.backgroundColor = [UIColor clearColor];
    
    
    if (grey){
        firstAlertTimeLabel.textColor = [UIColor colorWithWhite:.5 alpha:.1];
        firstAlertCell.contentView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.1];
        firstAlertCell.accessoryView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.1];
    }
    else{
        firstAlertTimeLabel.textColor = sharedData.redColor;
    }
    [self.tableView reloadData];
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!setEventSwitch.on) {
        firstAlertCell.detailTextLabel.text = @"";
        [self changeCellColor:YES];
        return nil;
    }
    else{
        NSString *firstAlertDefault = [[NSUserDefaults standardUserDefaults] stringForKey:@"1stAlert"];
        _1stAlert = firstAlertDefault;
        [self changeCellColor:NO];
        return indexPath;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

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
        //check for defaults set
        NSString *setEventAlertSwitch = [[NSUserDefaults standardUserDefaults] stringForKey:@"setAlertEvent"];
        if ([setEventAlertSwitch isEqualToString:@"yes"] ||setEventAlertSwitch == NULL){//check for switch yes or first time loading
            if (firstAlertDefault == NULL){
                _1stAlert = @"15 minutes before";
                [[NSUserDefaults standardUserDefaults] setObject:_1stAlert forKey:@"1stAlert"];//set this as initial default
            }
            else{
                _1stAlert = firstAlertDefault;
            }
        }
    }
    return self;
}

//transition between master and detail view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Pick1stAlert"]) {
        FirstAlertViewController *firstAlertViewController = segue.destinationViewController;
        firstAlertViewController.delegate = self;
        firstAlertViewController.alert = _1stAlert;
    }
}
- (void)firstAlertViewController:(FirstAlertViewController *)controller didSelectAlert:(NSString *)alert
{
    _1stAlert = alert;
    firstAlertCell.detailTextLabel.text = _1stAlert;
    [[NSUserDefaults standardUserDefaults] setObject:_1stAlert forKey:@"1stAlert"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)customizeView{
    [self.navigationController.navigationBar setHidden:YES];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [self.tabBarController.tabBar setHidden:NO];
}
@end
