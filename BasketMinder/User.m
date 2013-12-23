//
//  User.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/23/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "User.h"

@implementation User

- (void) setEmail:(NSString *)email{
    _email = email;
    email = [email lowercaseString];
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"preferEmail"]; //default value stored on phone
}

- (void) setPassword:(NSString *)password{
    _password = password;
     [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"preferPassword"];
    
}

//Designated initializer
- (id) initWithEmail:(NSString *)email{
    self = [super init];//initialized instance of user
    
    if(self){
        self.email = email;
    }
    
    return self;
    
}
//Convenience constructor
+ (id) userWithEmail:(NSString *) email{
    return [[self alloc] initWithEmail:email];//calls initializer and then allocates what is returned
}

@end
