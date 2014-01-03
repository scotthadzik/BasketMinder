//
//  PageRootViewController.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 1/2/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface PageRootViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

- (IBAction)doneWalkThrough:(id)sender;

@end
