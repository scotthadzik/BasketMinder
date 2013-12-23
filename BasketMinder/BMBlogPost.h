//
//  BMBlogPost.h
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/22/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMBlogPost : NSObject{
    //NSString *title;  //don't need instance variables
    //NSString *author;
}

@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *author;

@property (nonatomic) int views;
//@property (nonatomic) BOOL unread;
@property (nonatomic, getter = isUnread)BOOL unread;

//Designated initializer
- (id) initWithTitle:(NSString *)title; //return type id in case the BlogPost return is invalid

//Convienence constructor
+ (id) blogPostWithTitle:(NSString *) title;

@end
