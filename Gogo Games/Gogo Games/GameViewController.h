//
//  GameViewController.h
//  Gogo Games
//
//  Created by Agustin Jose Mazzeo on 8/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController
//Esta variable almacenera el dato del juego que se visualizara.
@property (nonatomic,strong) NSDictionary* game;

@property (strong, nonatomic) IBOutlet UITextView *descriptionGameTextView;


@end
