//
//  Database.h
//  Gogo Games
//
//  Created by Agustin Jose Mazzeo on 9/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject
-(id)initWithDocumentPathApplication;
-(NSString*)databasePath;
-(BOOL)checkIfDatabaseExist:(NSString*)nameDatabase;
-(BOOL)createDatabase:(NSString*)nameDatabase database:(sqlite3 *) database;
-(BOOL)createTableInDatabase:(NSString*)nameDatabase database:(sqlite3*)database sqlStatement:(NSString*)sqlStatement;
-(BOOL)saveDataInDatabase:(NSString*)nameDatabase database:(sqlite3*)database sqlStatement:(NSString*)sqlStatement;
@end
