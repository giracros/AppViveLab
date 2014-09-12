//
//  GameReviewViewController.m
//  Gogo Games
//
//  Created by Agustin Jose Mazzeo on 9/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import "GameReviewViewController.h"
#import "User.h"
#import "UserReviewViewController.h"
#import "GameUserReviewTableViewCell.h"
#import "Database.h"

@interface GameReviewViewController () {
    UIAlertView * alert;
    BOOL _userLogin;
    UserReviewViewController * userReview;
    NSMutableArray* _gameUsersReviews;
    NSMutableArray* _gameUsersReviews_User_ID;
    NSMutableArray* _gameUsersReviews_Game_Title;
    NSMutableArray* _gameUsersReviews_Game_Score;
    NSMutableArray* _gameUsersReviews_Game_Comment;
    sqlite3* _gamesReviews;
}

@end

@implementation GameReviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Configuro Background.
    [self.gameReviews setBackgroundView:nil];
    [self.gameReviews setBackgroundColor:[UIColor clearColor]];
    
    UIImageView* backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background-LowerLayer-1"]];
    backgroundImageView.frame = CGRectMake(0, 0, 320, 568);
    //backgroundImageView.alpha = 0.5f;
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    _gameUsersReviews_User_ID = [[NSMutableArray alloc]init];
    _gameUsersReviews_Game_Title = [[NSMutableArray alloc]init];
    _gameUsersReviews_Game_Score = [[NSMutableArray alloc]init];
    _gameUsersReviews_Game_Comment = [[NSMutableArray alloc]init];
    
    self.gameTitleReviewabel.text = _gameTitle;
    
    _gameUsersReviews = [[NSMutableArray alloc]initWithObjects:@"Review1",@"Review2",@"Review3", nil];
    
    Database* database = [[Database alloc]initWithDocumentPathApplication];
    
    NSString* completeDatabasePath = [[NSString alloc]initWithString:[[database databasePath] stringByAppendingPathComponent:@"gamesReviews.db"]];
    const char * databasePath = [completeDatabasePath UTF8String];
    
    NSString * sqlSelectUserReview = [[NSString alloc] initWithFormat:@"SELECT USER_ID, GAME_TITLE, GAME_SCORE, GAME_COMMENT FROM GAMESREVIEWS WHERE GAME_ID = \"%@\"",_gameTitle];
    //NSLog(@"%@",sqlSelectUserReview);
    const char * select_sql = [sqlSelectUserReview UTF8String];
    sqlite3_stmt * statement;
    
    if (sqlite3_open(databasePath,&_gamesReviews)==SQLITE_OK){
        if (sqlite3_prepare_v2(_gamesReviews, select_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSLog(@"Hay 1 Registro");

                [_gameUsersReviews_User_ID addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)]];
                [_gameUsersReviews_Game_Title addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 1)]];
                [_gameUsersReviews_Game_Score addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 2)]];
                [_gameUsersReviews_Game_Comment addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 3)]];
                //NSLog(@"%@",[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 3)])
                ;
            }
            NSLog(@"Finalizo While");
            sqlite3_finalize(statement);
            sqlite3_close(_gamesReviews);
        } else {
            NSLog(@"Error SQL");
        }
        sqlite3_close(_gamesReviews);
    }
    self.userScoreLabel.text = [self calculateUsersScore:_gameUsersReviews_Game_Score];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{

    if (_userLogin) {
        return YES;
    }
    
    alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                       message:@"Please, log on first."
                                      delegate:self
                             cancelButtonTitle:@"Accept"
                             otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    userReview = [segue destinationViewController];
    userReview.myDelegate = self; //Delegado
    userReview.user = [self.userLoginLabel.text substringFromIndex:6];
    userReview.gameTitle = self.gameTitleReviewabel.text;
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logonButton:(id)sender {
    if (!_userLogin) {
        alert = [[UIAlertView alloc] initWithTitle:@"Login User"
                                           message:@"Enter user and password"
                                          delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 otherButtonTitles:@"Accept",nil];
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [alert show];
    } else {
        _userLogin = NO;
        self.userLoginLabel.text = @"No user login";
        [self.logonButton setTitle:@"Log in" forState:UIControlStateNormal];
    }
}

//Delegado
-(void)userReviewViewControllerDismissed:(NSInteger)action userId:(NSString*)userID gameTitle:(NSString*)gameTitle gameScore:(NSString*)gameScore gameComment:(NSString*)gameComment {
    NSLog(@"Se llamo cuando se hizo dismiss del userreviewgamecontroller");
    NSLog(@"Accion: %li",(long)action);
    switch (action) {
        case 0: {
            NSLog(@"None");
            break;
        }
        case 1: {
            NSLog(@"Insert");
            NSUInteger indexInsert = [_gameUsersReviews_User_ID count];
            NSLog(@"%lu",(unsigned long)indexInsert);
            [_gameUsersReviews_User_ID addObject:userID];
            [_gameUsersReviews_Game_Title addObject:gameTitle];
            [_gameUsersReviews_Game_Score addObject:gameScore];
            [_gameUsersReviews_Game_Comment addObject:gameComment];
            
            NSArray* insertIndexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexInsert inSection:0], nil];
            
            [self.gameReviews beginUpdates];
            [self.gameReviews insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
            [self.gameReviews endUpdates];
            self.userScoreLabel.text = [self calculateUsersScore:_gameUsersReviews_Game_Score];
            break;
        }
        case 2: {
            NSLog(@"Update");
            NSUInteger indexUpdate = [_gameUsersReviews_User_ID indexOfObject:userID];
            NSLog(@"%lu",(unsigned long)indexUpdate);
            
            //[_gameUsersReviews_User_ID replaceObjectAtIndex:indexUpdate withObject: userID];
            [_gameUsersReviews_Game_Title replaceObjectAtIndex:indexUpdate withObject:gameTitle];
            [_gameUsersReviews_Game_Score replaceObjectAtIndex:indexUpdate withObject:gameScore];
            [_gameUsersReviews_Game_Comment replaceObjectAtIndex:indexUpdate withObject:gameComment];
            
            NSArray* updateIndexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexUpdate inSection:0], nil];
            
            [self.gameReviews reloadRowsAtIndexPaths:updateIndexPaths withRowAnimation:UITableViewRowAnimationMiddle];
            break;
            self.userScoreLabel.text = [self calculateUsersScore:_gameUsersReviews_Game_Score];
        }
        case 3: {
            NSLog(@"Delete");
            NSUInteger indexDelete = [_gameUsersReviews_User_ID indexOfObject:userID];
            NSLog(@"%lu",(unsigned long)indexDelete);
            if (!(indexDelete==NSNotFound)) {
                
                [_gameUsersReviews_User_ID removeObjectAtIndex:indexDelete];
                [_gameUsersReviews_Game_Title removeObjectAtIndex:indexDelete];
                [_gameUsersReviews_Game_Score removeObjectAtIndex:indexDelete];
                [_gameUsersReviews_Game_Comment removeObjectAtIndex:indexDelete];
            
                NSArray* deleteIndexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexDelete inSection:0], nil];
            
                [self.gameReviews beginUpdates];
                [self.gameReviews deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                [self.gameReviews endUpdates];
                self.userScoreLabel.text = [self calculateUsersScore:_gameUsersReviews_Game_Score];
            }
            break;
        }
    }
}
//Delegado

-(NSString*)calculateUsersScore:(NSMutableArray*)gameUsersScore {
    float average = 0;
    int count = 0;
    for (NSString* gameUserScore in gameUsersScore) {
        average += [gameUserScore floatValue];
        count++;
    }
    if (count != 0) {
        average = average / count;
    }
    return [NSString stringWithFormat:@"%.01f",average];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    User* user = [[User alloc]init];
    
    if (buttonIndex == 1) {
        NSLog(@"User: %@ - Password: %@",[alert textFieldAtIndex:0].text,[alert textFieldAtIndex:1].text);
        _userLogin = [user validateLogin:[alert textFieldAtIndex:0].text andPassword:[alert textFieldAtIndex:1].text];
        
        if (_userLogin) {
            self.userLoginLabel.text = [NSString stringWithFormat:@"Hola, %@",[alert textFieldAtIndex:0].text];
            [self.logonButton setTitle:@"Log Out" forState:UIControlStateNormal];
        } else {
            alert = [[UIAlertView alloc] initWithTitle:@"Error Login"
                                               message:@"User and/or password incorrect."
                                              delegate:self
                                     cancelButtonTitle:@"Accept"
                                     otherButtonTitles:nil];
            
            alert.alertViewStyle = UIAlertViewStyleDefault;
            [alert show];
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"%i",[_gameUsersReviews_User_ID count]);
    return [_gameUsersReviews_User_ID count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath    {
    static  NSString *cellIdentifier = @"gameUserReviewCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gameUserReviewCell"];
    GameUserReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //NSLog(@"%@",[_gameUsersReviews objectAtIndex:indexPath.row]);
    //cell.textLabel.text = [_gameUsersReviews objectAtIndex:indexPath.row];
    //cell.titleLabel.text = [_gameUsersReviews objectAtIndex:indexPath.row];
    cell.titleLabel.text = [_gameUsersReviews_Game_Title objectAtIndex:indexPath.row];
    cell.scoreLabel.text = [_gameUsersReviews_Game_Score objectAtIndex:indexPath.row];
    cell.userLabel.text = [NSString stringWithFormat:@"from %@",[_gameUsersReviews_User_ID objectAtIndex:indexPath.row]];
    cell.commentLabel.text = [_gameUsersReviews_Game_Comment objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
@end
