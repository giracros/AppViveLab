//
//  GameUserReviewTableViewCell.h
//  Gogo Games
//
//  Created by Agustin Jose Mazzeo on 9/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameUserReviewTableViewCell : UITableViewCell

@property (strong,nonatomic) IBOutlet UILabel *titleLabel;
@property (strong,nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong,nonatomic) IBOutlet UILabel *userLabel;
@property (strong,nonatomic) IBOutlet UILabel *commentLabel;

@end
