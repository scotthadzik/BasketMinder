//
//  BillingInformationViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 1/4/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import "BillingInformationViewController.h"
#import "UICKeyChainStore.h"
#import "SettingsViewController.h"
#import "globals.h"


@interface BillingInformationViewController () <UITextFieldDelegate>

@end

@implementation BillingInformationViewController

@synthesize cardNumber,nameOnCard,billingAddress, billingCity, billingState, billingZipCode;
@synthesize saveText;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeView];

    self.cardNumber.delegate = self;
    self.nameOnCard.delegate = self;
    self.billingAddress.delegate = self;
    self.billingCity.delegate = self;
    self.billingZipCode.delegate = self;
    self.billingState.delegate = self;
    
    globals *sharedData = [globals sharedData];
    [self.saveText setTintColor:(sharedData.redColor)];

    [self keyboardCustomizer];
    [self checkForValuesStored];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self customizeView];
    [self checkForValuesStored];
    
    BOOL disclaimerShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"recomendationsShown"];
    if (!disclaimerShown) {
        [self showRecomendations];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"recomendationsShown"];
    }
    
    

}

-(void)keyboardCustomizer{
    //For dismiss keyboard addded toolbar
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(saveButton:)],
                         nil];
    [doneToolbar sizeToFit];
    billingZipCode.inputAccessoryView = doneToolbar;
}

- (void)showRecomendations{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"The information on this page is securely stored on your device’s keychain. As an added security feature we recommend that you set a passcode for your device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

//for moving to the next textfield when return pressed on keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(theTextField==self.nameOnCard){
        [self.cardNumber becomeFirstResponder];
    }
    if(theTextField==self.cardNumber){
        [self.billingAddress becomeFirstResponder];
    }
    if(theTextField==self.billingAddress){
        [self.billingCity becomeFirstResponder];
    }
    if(theTextField==self.billingCity){
        [self.billingState becomeFirstResponder];
    }
    if(theTextField==self.billingState){
        [self.billingZipCode becomeFirstResponder];
    }
    if(theTextField==self.billingZipCode){
        [theTextField resignFirstResponder];
    }
    return YES;
}
-(void)checkForValuesStored{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    nameOnCard.text = [store stringForKey:@"nameOnCard"];
    cardNumber.text = [store stringForKey:@"cardNumber"];
    billingAddress.text = [store stringForKey:@"billingAddress"];
    billingCity.text = [store stringForKey:@"billingCity"];
    billingState.text = [store stringForKey:@"billingState"];
    billingZipCode.text = [store stringForKey:@"billingZip"];
}

- (IBAction)saveButton:(id)sender {
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    [store setString:nameOnCard.text forKey:@"nameOnCard"];
    [store setString:cardNumber.text forKey:@"cardNumber"];
    [store setString:billingAddress.text forKey:@"billingAddress"];
    [store setString:billingCity.text forKey:@"billingCity"];
    [store setString:billingState.text forKey:@"billingState"];
    [store setString:billingZipCode.text forKey:@"billingZip"];
    
    [store synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)customizeView{
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
}
@end
