//
//  BMBlogPost.m
//  BasketMinder
//
//  Created by Bryan Hadzik on 12/22/13.
//  Copyright (c) 2013 Bryan Hadzik. All rights reserved.
//

#import "BMBlogPost.h"

@implementation BMBlogPost


////setter and getter
//- (void) setTitle: (NSString *) _title {
//    title = _title;
//}
//- (NSString *) title{
//    return title;
//}

- (id) initWithTitle:(NSString *)title{
    self = [super init];//initiallized instance of blog post
    
    if (self){   //check for valid instance
        self.title = title;
        
    }
    
    return self;
}

+ (id) blogPostWithTitle:(NSString *) title{
    return [[self alloc] initWithTitle:title]; //calls initializer and then allocates what is returned
}



@end
