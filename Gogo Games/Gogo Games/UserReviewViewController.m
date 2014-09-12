//
//  UserReviewViewController.m
//  Gogo Games
//
//  Created by Agustin Jose Mazzeo on 9/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import "UserReviewViewController.h"
#import "Database.h"

@interface UserReviewViewController () {
    sqlite3 * _gameReview;
    BOOL _editGameReview;
    UIAlertView* alert;
    NSInteger _actionDataBase;
}

@end

@implementation UserReviewViewController

@synthesize myDelegate; //Delegado

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
    UIImageView* backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background-LowerLayer-1"]];
    backgroundImageView.frame = CGRectMake(0, 0, 320, 568);
    //backgroundImageView.alpha = 0.5f;
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    _actionDataBase = 0; //None
    self.commentTextView.delegate = self;
    self.scoreReviewTextField.delegate = self;
    
    self.userLabel.text = [NSString stringWithFormat:@"Hola, %@",_user];
    self.gameTitleLabel.text = _gameTitle;

    Database* database = [[Database alloc]initWithDocumentPathApplication];
    
    NSString* completeDatabasePath = [[NSString alloc]initWithString:[[database databasePath] stringByAppendingPathComponent:@"gamesReviews.db"]];
    const char * databasePath = [completeDatabasePath UTF8String];
    
    NSString * sqlSelectUserReview = [[NSString alloc] initWithFormat:@"SELECT GAME_TITLE, GAME_SCORE, GAME_COMMENT FROM GAMESREVIEWS WHERE GAME_ID = \"%@\" AND USER_ID = \"%@\"",_gameTitle,_user];
    const char * select_sql = [sqlSelectUserReview UTF8String];
    sqlite3_stmt * statement;
    
    if (sqlite3_open(databasePath,&_gameReview)==SQLITE_OK){
        if (sqlite3_prepare_v2(_gameReview, select_sql, -1, &statement, NULL)==SQLITE_OK) {
            if (sqlite3_step(statement)==SQLITE_ROW) {
                NSLog(@"Game Review Existe");
                _editGameReview = YES;
                _titleUserReview = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)];
                self.titleReviewTexField.text = _titleUserReview;
                _scoreUserReview = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 1)];
                self.scoreReviewTextField.text = _scoreUserReview;
                _commentUserReview = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 2)];
                self.commentTextView.text = _commentUserReview;

            } else {
                NSLog(@"Game Review No Existe");
                _editGameReview = NO;
                _titleUserReview =  @"";
                self.titleReviewTexField.text = _titleUserReview;
                 _scoreUserReview = @"";
                self.scoreReviewTextField.text =  _scoreUserReview;
                _commentUserReview = @"";
                self.commentTextView.text = _commentUserReview;
            }
            sqlite3_finalize(statement);
            sqlite3_close(_gameReview);
        } else {
            NSLog(@"Error SQL");
        }
        sqlite3_close(_gameReview);
    }
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

- (IBAction)backButton:(id)sender {
    NSInteger action;
    if (_editGameReview) {
        [self.myDelegate userReviewViewControllerDismissed:_actionDataBase userId:_user gameTitle:_titleUserReview gameScore:_scoreUserReview gameComment:_commentUserReview]; //Delegado
    } else{
        if (_actionDataBase == 2) {
            action = 1;
            [self.myDelegate userReviewViewControllerDismissed:action userId:_user gameTitle:_titleUserReview gameScore:_scoreUserReview gameComment:_commentUserReview];
        } //else if (_actionDataBase == 3) {
            //action = 0;
            //[self.myDelegate userReviewViewControllerDismissed:action userId:_user gameTitle:_titleUserReview gameScore:_scoreUserReview gameComment:_commentUserReview];
        //} else {
        [self.myDelegate userReviewViewControllerDismissed:_actionDataBase userId:_user gameTitle:_titleUserReview gameScore:_scoreUserReview gameComment:_commentUserReview];
        //}
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)gameTitleLabel:(id)sender {
    [sender resignFirstResponder];
    [self.scoreReviewTextField becomeFirstResponder];
}

- (IBAction)scoreReviewTextField:(id)sender {
    [sender resignFirstResponder];
    [self.commentTextView becomeFirstResponder];
}

- (IBAction)updateGameReviewButton:(id)sender {

    if (([self.titleReviewTexField.text isEqualToString: @""]) || ([self.scoreReviewTextField.text isEqualToString: @""]) || ([self.commentTextView.text isEqualToString: @""])) {
        NSLog(@"Campos Vacios");
        alert = [[UIAlertView alloc] initWithTitle:@"Error Data"
                                           message:@"Title and/or Score and/or Comment is empty."
                                          delegate:self
                                 cancelButtonTitle:@"Accept"
                                 otherButtonTitles:nil];
        
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    } else {
        [self updateGameReview:0];
    }
}

- (IBAction)deleteGameReviewButton:(id)sender {
    [self updateGameReview:1];
}

- (void)updateGameReview:(int)index {
    Database* database = [[Database alloc]initWithDocumentPathApplication];
    NSString * sql = [[NSString alloc]init];
    switch (index) {
          
        case 0:
            if (_editGameReview) {
                //UPDATE
                sql = [NSString stringWithFormat:@"UPDATE GAMESREVIEWS SET GAME_TITLE = \"%@\", GAME_SCORE = \"%@\", GAME_COMMENT = \"%@\" WHERE GAME_ID = \"%@\" AND USER_ID = \"%@\"",self.titleReviewTexField.text,self.scoreReviewTextField.text,self.commentTextView.text,self.gameTitleLabel.text,self.user];
                //NSLog(@"%@",sql);
                if ([database saveDataInDatabase:@"gamesReviews.db" database:_gameReview sqlStatement:sql]) {
                    NSLog(@"Base de Datos Actualizada - Update");
                    alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                       message:@"User's game review updated"
                                                      delegate:self
                                             cancelButtonTitle:@"Accept"
                                             otherButtonTitles:nil];
                    
                    alert.alertViewStyle = UIAlertViewStyleDefault;
                    [alert show];
                    _actionDataBase = 2; //Update
                    _titleUserReview = self.titleReviewTexField.text;
                    _scoreUserReview = self.scoreReviewTextField.text;
                    _commentUserReview = self.commentTextView.text;
                } else {
                    NSLog(@"Error al Actualizar Base de Datos - Update");
                }
            } else {
                //INSERT
                sql = [NSString stringWithFormat:@"INSERT INTO GAMESREVIEWS (GAME_ID, USER_ID, GAME_TITLE, GAME_SCORE, GAME_COMMENT) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",self.gameTitleLabel.text,self.user,self.titleReviewTexField.text,self.scoreReviewTextField.text,self.commentTextView.text];
                //NSLog(@"%@",sql);
                if ([database saveDataInDatabase:@"gamesReviews.db" database:_gameReview sqlStatement:sql]) {
                    NSLog(@"Base de Datos Actualizada - Insert");
                    _editGameReview = YES;
                    alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                       message:@"User's game review updated"
                                                      delegate:self
                                             cancelButtonTitle:@"Accept"
                                             otherButtonTitles:nil];
                    
                    alert.alertViewStyle = UIAlertViewStyleDefault;
                    [alert show];
                    _actionDataBase = 1; //Insert
                    _titleUserReview = self.titleReviewTexField.text;
                    _scoreUserReview = self.scoreReviewTextField.text;
                    _commentUserReview = self.commentTextView.text;
                } else {
                    NSLog(@"Error al Actualizar Base de Datos - Insert");
                }
            }
            break;
        case 1:
                //DELETE
            if (_editGameReview) {
                sql = [NSString stringWithFormat:@"DELETE FROM GAMESREVIEWS WHERE GAME_ID = \"%@\" AND USER_ID = \"%@\"",self.gameTitleLabel.text,self.user];
                //NSLog(@"%@",sql);
                if ([database saveDataInDatabase:@"gamesReviews.db" database:_gameReview sqlStatement:sql]) {
                    NSLog(@"Base de Datos Actualizada - Delete");
                    self.titleReviewTexField.text = @"";
                    self.scoreReviewTextField.text = @"";
                    self.commentTextView.text = @"";
                    _editGameReview = NO;
                    alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                       message:@"User's game review deleted"
                                                      delegate:self
                                             cancelButtonTitle:@"Accept"
                                             otherButtonTitles:nil];
                    
                    alert.alertViewStyle = UIAlertViewStyleDefault;
                    [alert show];
                     _actionDataBase = 3; //Delete
                    _titleUserReview = @"";
                    _scoreUserReview = @"";
                    _commentUserReview = @"";
                } else {
                    NSLog(@"Error al Actualizar Base de Datos - Delete");
                }
            } else {
                self.titleReviewTexField.text = @"";
                self.scoreReviewTextField.text = @"";
                self.commentTextView.text = @"";
                _titleUserReview = @"";
                _scoreUserReview = @"";
                _commentUserReview = @"";
            }
            break;
    }
    
}

//Limite a 60 caractetes este TextView y ademas baja el teclado cuando se pulsa enter.
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.commentTextView resignFirstResponder];
    }
    NSUInteger maxLength = [textView.text length] + [text length] - range.length;
    
    return (maxLength > 255) ? NO : YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%@",string);
    //Primero Valido que los caracteres ingresado sean 1-9 o .
    NSCharacterSet* numbersOnly =  [NSCharacterSet characterSetWithCharactersInString:@"1234567890."];
    NSCharacterSet* charactersSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:charactersSetFromTextField];
    if (!stringIsValid) {
        return NO;
    }
    
    //Valido que no se empiece por .
    //NSLog(@"%i",self.scoreReviewTextField.text.length);
    if ([string isEqualToString:@"."] && self.scoreReviewTextField.text.length ==0) {
        return NO;
    }
    
    //Ahora valido que no se ingrese mas de un .
    NSRange charPosition = [self.scoreReviewTextField.text rangeOfString:@"."];
    if ((charPosition.location != NSNotFound) && ([string isEqualToString:@"."])) {
        return NO;
    }
    
    //Ahora valido que el numero este entre 0 y 10
    NSString* valueString = [NSString stringWithFormat:@"%@%@",self.scoreReviewTextField.text,string];
    float value = [valueString floatValue];
    NSLog(@"%f",value);
    if ((value<0) || (value>10)){
        return NO;
    }
    
    //Si el valor ingresado ya es 10 no se permite mas caracteres
    if ([self.scoreReviewTextField.text isEqualToString:@"10"] && (![string  isEqual: @""])) {
        return NO;
    }
    
    //Ahora no permito mas de 3 caracteres
    NSUInteger maxLength = [self.scoreReviewTextField.text length] + [string length] - range.length;
    return (maxLength > 3) ? NO : YES;
}

@end
