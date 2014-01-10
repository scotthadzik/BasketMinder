//
//  globals.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 1/10/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import "globals.h"

@implementation globals

@synthesize redColor;

#pragma mark singleton methods
+(id)sharedData{
    static globals *sharedMyData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyData = [[self alloc] init];
    });
    return sharedMyData;
}

- (id)init {
    if (self = [super init]) {
        redColor = [[UIColor alloc] initWithRed:0.608 green:0.22 blue:0.22 alpha:1.0];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
