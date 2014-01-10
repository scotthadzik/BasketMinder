//
//  globals.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 1/10/14.
//  Copyright (c) 2014 Bryan Hadzik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface globals : NSObject{
    UIColor *redColor;
}

@property(nonatomic, retain) UIColor *redColor;

+(id)sharedData;

@end
