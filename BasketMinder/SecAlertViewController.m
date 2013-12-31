//
//  SecAlertViewController.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/28/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "SecAlertViewController.h"

@interface SecAlertViewController ()

@end

@implementation SecAlertViewController{
    NSArray *_alerts;
    NSUInteger _selectedIndex;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];


    _alerts = @[@"None",
               @"At time of event",
               @"5 minutes before",
               @"15 minutes before",
               @"30 minutes before",
               @"1 hour before",
               @"2 hours before",
               @"1 day before",
               @"2 days before",
               @"1 week before"];
    _selectedIndex = [_alerts indexOfObject:self.alert];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_alerts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertCell"];
    
    cell.textLabel.text = _alerts[indexPath.row];
    
    if (indexPath.row == _selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_selectedIndex != NSNotFound) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:
                                 [NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    _selectedIndex = indexPath.row;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSString *alert = _alerts[indexPath.row];
    [self.delegate secAlertViewController:self didSelectAlert:alert];
}

@end
