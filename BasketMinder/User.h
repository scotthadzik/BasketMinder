//
//  User.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/23/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong)NSString *email;
@property (nonatomic, strong)NSString *password;
//@property (nonatomic)BOOL currentUser;

//Designated initializer
- (id) initWithEmail:(NSString *)email;

//Convienance constructor
+ (id) emailWithPassword:(NSString *) password;


@end
