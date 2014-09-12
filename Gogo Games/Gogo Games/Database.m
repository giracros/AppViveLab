//
//  Database.m
//  Gogo Games
//
//  Created by Agustin Jose Mazzeo on 9/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import "Database.h"

@implementation Database {
    NSString* _databasePath;
}

-(NSString*)databasePath {
    return _databasePath;
}

-(void)setDatabasePath{
    NSString * docsDir;
    NSArray * dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    _databasePath = docsDir;
}

-(id)initWithDocumentPathApplication{
    self = [super init];
    if (self) {
        [self setDatabasePath];
    }
    return self;
}

-(BOOL)createDatabase:(NSString*)nameDatabase database:(sqlite3 *) database{
    NSString* completeDatabasePath = [[NSString alloc]initWithString:[_databasePath stringByAppendingPathComponent:nameDatabase]];
    const char * databasePath = [completeDatabasePath UTF8String];
    
    if (sqlite3_open(databasePath, &database)==SQLITE_OK) {
        //NSLog(@"Base de Datos Creados");
        sqlite3_close(database);
        return YES;
    }
    return NO;
}

-(BOOL)checkIfDatabaseExist:(NSString*)nameDatabase {
    NSString* completeDatabasePath = [[NSString alloc]initWithString:[_databasePath stringByAppendingPathComponent:nameDatabase]];
    NSFileManager * fileManager = [[NSFileManager alloc]init];
    
    if ([fileManager fileExistsAtPath:completeDatabasePath]==YES) {
        return YES;
    }
    return NO;
}

-(BOOL)createTableInDatabase:(NSString*)nameDatabase database:(sqlite3*)database sqlStatement:(NSString*)sqlStatement{
    NSString* completeDatabasePath = [[NSString alloc]initWithString:[_databasePath stringByAppendingPathComponent:nameDatabase]];
    const char * databasePath = [completeDatabasePath UTF8String];
    const char * sql = [sqlStatement UTF8String];
    char * errorMessage;
    
    if (sqlite3_open(databasePath,&database)==SQLITE_OK){
        if (sqlite3_exec(database, sql, NULL, NULL, &errorMessage)==SQLITE_OK) {
            
            sqlite3_close(database);
            return YES;
        }
    }
    return NO;
}

-(BOOL)saveDataInDatabase:(NSString*)nameDatabase database:(sqlite3*)database sqlStatement:(NSString*)sqlStatement{
    NSString* completeDatabasePath = [[NSString alloc]initWithString:[_databasePath stringByAppendingPathComponent:nameDatabase]];
    const char * databasePath = [completeDatabasePath UTF8String];
    const char * insert_sql = [sqlStatement UTF8String];
    sqlite3_stmt * statement;

    if (sqlite3_open(databasePath,&database)==SQLITE_OK){
        sqlite3_prepare_v2(database,insert_sql,-1,&statement,NULL);
        if (sqlite3_step(statement)==SQLITE_DONE) {
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return YES;
        } else {
            sqlite3_close(database);
            return NO;
        }
    }
    return NO;
}
@end
