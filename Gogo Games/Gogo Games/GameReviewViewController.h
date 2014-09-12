//
//  GameReviewViewController.h
//  Gogo Games
//
//  Created by Agustin Jose Mazzeo on 9/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserReviewViewController.h" //Delegado

@interface GameReviewViewController : UIViewController <UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,SecondDelegate> {//Add Delegado
    GameReviewViewController* gameReviewViewController; //Delegado
}

@property NSString * gameTitle;

@property (weak, nonatomic) IBOutlet UILabel *gameTitleReviewabel;
@property (weak, nonatomic) IBOutlet UILabel *userLoginLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *logonButton;

@property (weak, nonatomic) IBOutlet UITableView *gameReviews;

- (IBAction)backButton:(id)sender;

- (IBAction)logonButton:(id)sender;

@end
