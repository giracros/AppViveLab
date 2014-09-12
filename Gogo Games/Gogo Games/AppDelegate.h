//
//  AppDelegate.h
//  Gogo Games
//
//  Created by Agustin Jose Mazzeo on 5/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//Almacena los Juegos Obtenidos del archivo JSON.
@property (readonly,nonatomic) NSArray* games;

@end
