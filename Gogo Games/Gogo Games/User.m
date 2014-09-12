//
//  User.m
//  Gogo Games
//
//  Created by Grupo 2 Medellin on 9/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import "User.h"
#import "Database.h"

@implementation User {
    sqlite3 * users;
}

-(BOOL)validateLogin: (NSString*)user andPassword:(NSString*)pass{
    Database* database = [[Database alloc]initWithDocumentPathApplication];
    
    NSString* completeDatabasePath = [[NSString alloc]initWithString:[[database databasePath] stringByAppendingPathComponent:@"gamesReviews.db"]];
    const char * databasePath = [completeDatabasePath UTF8String];
    
    NSString * sqlSelectUser = [[NSString alloc] initWithFormat:@"SELECT USER_PASSWORD FROM USERS WHERE USER_ID = \"%@\"",user];
    const char * select_sql = [sqlSelectUser UTF8String];
    sqlite3_stmt * statement;
    
    if (sqlite3_open(databasePath,&users)==SQLITE_OK){
        if (sqlite3_prepare_v2(users, select_sql, -1, &statement, NULL)==SQLITE_OK) {
            if (sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Usuario Encontrado");
                NSString* userPassword = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)];

                //if (([user  isEqualToString: @"admin"]) && ([pass  isEqualToString: @"123"])) {
                if ([userPassword  isEqualToString: pass]) {
                    NSLog(@"Password Match");
                    sqlite3_finalize(statement);
                    sqlite3_close(users);
                    return YES;
                } else {
                    NSLog(@"Password No Match");
                    sqlite3_finalize(statement);
                    sqlite3_close(users);
                }
            }
        } else {
            NSLog(@"Usuario No Encontrado");
            sqlite3_close(users);
        }
    }
    return NO;
}

@end
