//
//  UserReviewViewController.h
//  Gogo Games
//
//  Created by Agustin Jose Mazzeo on 9/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import <UIKit/UIKit.h>

//Delegado
@protocol SecondDelegate <NSObject>

-(void)userReviewViewControllerDismissed:(NSInteger)action userId:(NSString*)userID gameTitle:(NSString*)gameTitle gameScore:(NSString*)gameScore gameComment:(NSString*)gameComment;

@end
//Delegado

@interface UserReviewViewController : UIViewController <UITextViewDelegate,UITextFieldDelegate> {
    id _myDelegate; //Delegado
}

@property (assign,nonatomic) id <SecondDelegate> myDelegate; //Delegado

@property NSString * user;
@property NSString * gameTitle;
@property NSString * titleUserReview;
@property NSString * scoreUserReview;
@property NSString * commentUserReview;

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleReviewTexField;
@property (weak, nonatomic) IBOutlet UITextField *scoreReviewTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

- (IBAction)backButton:(id)sender;

- (IBAction)gameTitleLabel:(id)sender;
- (IBAction)scoreReviewTextField:(id)sender;
- (IBAction)updateGameReviewButton:(id)sender;
- (IBAction)deleteGameReviewButton:(id)sender;

@end
