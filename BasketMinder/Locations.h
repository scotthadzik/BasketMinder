//
//  Locations.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/26/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Locations : NSObject

@property (strong, nonatomic) NSString *state;
//@property (strong, nonatomic) NSMutableArray *city;
//@property (strong, nonatomic) NSMutableArray *location;

//Designated initializer
- (id) initWithState:(NSString *)state;

//Convienance constructor
+ (id) locationsWithState:(NSString *) state;




@end
