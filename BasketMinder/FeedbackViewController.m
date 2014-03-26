//
//  FeedbackViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 1/4/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import "FeedbackViewController.h"


@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Contacting Tank Jig Studios" message:@"The feedback link on this page is intended for providing feedback to TankJig Studios in regards to the BasketMinder application. If you are experiencing any problems with the functionality of the app please provide us with feedback. \n\n Any problems or questions regarding orders, refunds, or site information should be directed to Bountiful Baskets Food Co-op" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

- (IBAction)sendFeedback:(id)sender {
  
    // Email Subject
    NSString *emailTitle = @"BasketMinder Feedback";
    // Email Content
    NSString *messageBody = @"\n\n\n\n\n";
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
//    NSString *phoneModel = [self IphoneModel];
    messageBody = [messageBody stringByAppendingString:@"Application Version: "];
    messageBody = [messageBody stringByAppendingString:appVersion];
    messageBody = [messageBody stringByAppendingString:@"\n" ];
    messageBody = [messageBody stringByAppendingString:@"Phone Model: " ];
//    messageBody = [messageBody stringByAppendingString:phoneModel];
    
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@tankjig.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];

}

//- (NSString *) IphoneModel {
//    size_t size;
//    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//    char *machine = (char*)malloc(size);
//    sysctlbyname("hw.machine", machine, &size, NULL, 0);
//    NSString *platform = [NSString stringWithCString:machine encoding: NSUTF8StringEncoding];
//    free(machine);
//    
//    return platform;
//}

@end
