//
//  AppDelegate.m
//  Gogo Games
//
//  Created by Agustin Jose Mazzeo on 5/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import "AppDelegate.h"
#import "Database.h"

@implementation AppDelegate
{
    //Defino variable array para almacenar la informacion del archivo: games.json
    NSArray* _games;
    sqlite3 * _gamesReviewsDatabase;
}

//Metodo Get: games
-(NSArray*)games {
    return _games;
}

// Metodo Set: Toma el archivo JSON y carga el contenido en el Array games.
-(void) loadGames {
    
    //Inicio - Este Codigo es SOLO para pruebas debe estar comentado
//    NSFileManager * fileManager = [[NSFileManager alloc]init];
//    NSError * error;
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString * basePath = ([paths count]>0 ? [paths objectAtIndex:0]:nil);
//    NSString* pathDelete = [basePath stringByAppendingString:@"/gamesReviews.db"];
//    
//    [fileManager removeItemAtPath:pathDelete error: &error];
//    
//    if (error) {
//        NSLog(@"Error Borrando Archivo %@", error);
//    }
//    NSLog(@"Borrado Exitoso");
    //Fin - Este Codigo es SOLO para pruebas debe estar comentado
    
    //Creo la base de datos.
    Database* database = [[Database alloc]initWithDocumentPathApplication];

    if (![database checkIfDatabaseExist:@"gamesReviews.db"]) {
        if ([database createDatabase:@"gamesReviews.db" database:_gamesReviewsDatabase]) {
            NSLog(@"Se crea la base de datos.");
            NSString * sqlCreateTableUser = [[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS USERS (USER_ID TEXT PRIMARY KEY,USER_PASSWORD TEXT)"];
            if ([database createTableInDatabase:@"gamesReviews.db" database:_gamesReviewsDatabase sqlStatement:sqlCreateTableUser]) {
                NSLog(@"Se crea la tabla user.");
                NSString * sqlCreateTableGamesReviews = [[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS GAMESREVIEWS (GAME_ID TEXT, USER_ID TEXT, GAME_TITLE TEXT, GAME_SCORE TEXT, GAME_COMMENT TEXT, PRIMARY KEY (GAME_ID, USER_ID))"];
                if ([database createTableInDatabase:@"gamesReviews.db" database:_gamesReviewsDatabase sqlStatement:sqlCreateTableGamesReviews]) {
                    NSLog(@"Se crea la tabla GamesReviews.");
                    NSString * sqlCreateUser = [[NSString alloc] initWithFormat:@"INSERT INTO USERS (USER_ID, USER_PASSWORD) VALUES (\"Admin\",\"123\")"];
                    if ([database saveDataInDatabase:@"gamesReviews.db" database:_gamesReviewsDatabase sqlStatement:sqlCreateUser]) {
                        NSLog(@"Inserta user Admin en la tabla Users.");
                    } else {
                        NSLog(@"No pudo insertar user en la tabla Users.");
                    }
                    sqlCreateUser = [NSString stringWithFormat:@"INSERT INTO USERS (USER_ID, USER_PASSWORD) VALUES (\"User\",\"456\")"];
                    if ([database saveDataInDatabase:@"gamesReviews.db" database:_gamesReviewsDatabase sqlStatement:sqlCreateUser]) {
                        NSLog(@"Inserta user User en la tabla Users.");
                    } else {
                        NSLog(@"No pudo insertar user en la tabla Users.");
                    }
                    sqlCreateUser = [NSString stringWithFormat:@"INSERT INTO USERS (USER_ID, USER_PASSWORD) VALUES (\"jcc\",\"juan\")"];
                    if ([database saveDataInDatabase:@"gamesReviews.db" database:_gamesReviewsDatabase sqlStatement:sqlCreateUser]) {
                        NSLog(@"Inserta user jcc en la tabla Users.");
                    } else {
                        NSLog(@"No pudo insertar user en la tabla Users.");
                    }
                    sqlCreateUser = [NSString stringWithFormat:@"INSERT INTO USERS (USER_ID, USER_PASSWORD) VALUES (\"dr\",\"david\")"];
                    if ([database saveDataInDatabase:@"gamesReviews.db" database:_gamesReviewsDatabase sqlStatement:sqlCreateUser]) {
                        NSLog(@"Inserta user dr en la tabla Users.");
                    } else {
                        NSLog(@"No pudo insertar user en la tabla Users.");
                    }
                    sqlCreateUser = [NSString stringWithFormat:@"INSERT INTO USERS (USER_ID, USER_PASSWORD) VALUES (\"df\",\"daniel\")"];
                    if ([database saveDataInDatabase:@"gamesReviews.db" database:_gamesReviewsDatabase sqlStatement:sqlCreateUser]) {
                        NSLog(@"Inserta user df en la tabla Users.");
                    } else {
                        NSLog(@"No pudo insertar user en la tabla Users.");
                    }
                    sqlCreateUser = [NSString stringWithFormat:@"INSERT INTO USERS (USER_ID, USER_PASSWORD) VALUES (\"ajm\",\"agus\")"];
                    if ([database saveDataInDatabase:@"gamesReviews.db" database:_gamesReviewsDatabase sqlStatement:sqlCreateUser]) {
                        NSLog(@"Inserta user ajm en la tabla Users.");
                    } else {
                        NSLog(@"No pudo insertar user en la tabla Users.");
                    }
                } else {
                    NSLog(@"No pudo crear la tabla GamesReviews.");
                }
                
            } else {
                 NSLog(@"No pudo crear la tabla user.");
            }
        } else {
            NSLog(@"No pudo crear la base de datos.");
        }
    } else {
        NSLog(@"La base de datos existe.");
    }
    
    //Esto se podria obtener de un servidor WEB pero se maneja por el momento de forma local.
    NSString* path = [[NSBundle mainBundle] pathForResource: @"games"
                                                     ofType: @"json"];
    
    NSString* data = [NSString stringWithContentsOfFile: path
                                               encoding: NSUTF8StringEncoding
                                                  error: nil];
    
    NSData* resultData = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    _games = [NSJSONSerialization JSONObjectWithData:resultData
                                             options:kNilOptions
                                               error:nil];
    
    //Ordeno Alfabeticamente el Array de Juegos por el titulo
    NSSortDescriptor* titleDescriptor = [[NSSortDescriptor alloc]initWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray* descriptors = [NSArray arrayWithObjects:titleDescriptor, nil];
    
    _games = [_games sortedArrayUsingDescriptors:descriptors];
    
    //NSLog(@"%@",_games);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self loadGames];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
