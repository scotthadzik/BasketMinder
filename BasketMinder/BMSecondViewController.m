//
//  BMSecondViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/18/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "BMSecondViewController.h"

@interface BMSecondViewController ()<UITextFieldDelegate>
    


@end

@implementation BMSecondViewController
@synthesize userEmail;
@synthesize userPassword;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
