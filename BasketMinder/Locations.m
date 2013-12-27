//
//  Locations.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/26/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "Locations.h"

@implementation Locations



//Designated initializer
- (id) initWithState:(NSString *)state{
    self = [super init];//initialized instance of user
    
    if(self){
        self.state = state;
    }
    
    return self;
    
}
//Convenience constructor
+ (id) locationsWithState:(NSString *) state{
    return [[self alloc] initWithState:state];//calls initializer and then allocates what is returned
}

@end
