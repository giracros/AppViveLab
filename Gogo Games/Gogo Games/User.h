//
//  User.h
//  Gogo Games
//
//  Created by Agustin Jose Mazzeo on 9/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

    -(BOOL)validateLogin: (NSString*)user andPassword:(NSString*)pass;
@end
