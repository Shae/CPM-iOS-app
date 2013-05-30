//
//  MainViewController.m
//  CPMsql_wk2
//
//  Created by Shae Klusman on 5/16/13.
//  Copyright (c) 2013 Shae Klusman. All rights reserved.
//

#import "MainViewController.h"
#import <Parse/Parse.h>
#import "AddWeapon.h"
#import "Weapon.h"
@interface MainViewController ()
{
    int selected;
    const char *UTF8dbpath;
    UIActivityIndicatorView *spinner;
    UIAlertView* load_message;
}
@end

@implementation MainViewController




- (void)viewDidLoad{
    [Parse setApplicationId:@"KOHAaQRdCYXrO1RNBYF3iTSOoxrgTfXRsFUpMdhN"
                  clientKey:@"P3BgADyELTJe2ZyJFUs5cqabAagdVtg517VG2YHf"];
    
    weaponsArray = [[NSMutableArray alloc] init];
    typesArray = [[NSMutableArray alloc] init];
    [typesArray addObject:@"ALL TYPES"];
    [typesArray addObject:@"Sword"];
    [typesArray addObject:@"Axe"];
    [typesArray addObject:@"Blunt"];
    [typesArray addObject:@"Missile"];
    
    [self buildDB];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)buildDB{
    NSLog(@"buildDB function Started");
    // Get the documents directory
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
    if (path != nil) {
        NSString *thepath = [path objectAtIndex:0];
        NSString *dbName = @"weaponsDB.sqlite";
        dbPath = [thepath stringByAppendingPathComponent:dbName];
        NSLog(@"Database Path= %@", dbPath);
        UTF8dbpath = [dbPath UTF8String];
        
        if (sqlite3_open(UTF8dbpath, &dbcontext) == SQLITE_OK)
        {
            
            // the database was either created or opened successfully
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS weapons ( weaponID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, type INTEGER NOT NULL, hands INTEGER NOT NULL, damage INTEGER NOT NULL, quantity INTEGER NOT NULL, parseID TEXT  )";
            
            if (sqlite3_exec(dbcontext, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                
            }
            const char* countStmnt = "SELECT * FROM weapons";
            sqlite3_stmt *statement;
            int count = 0;
            if( sqlite3_prepare_v2(dbcontext, countStmnt, -1, &statement, NULL) == SQLITE_OK )
            {
                //Loop through all the returned rows
                while( sqlite3_step(statement) == SQLITE_ROW )
                {
                    count++;
                    
                }
                NSLog(@"row count %d", count);
                if (count == 0) {
                    [self loadingSpinner];
                    //[self insertDataintoDB];  ////////////////  ADD DATA INTO DB
                    NSLog(@"calling for data insert");
                    PFQuery *query = [PFQuery queryWithClassName:@"weaponsTablePARSE"];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            
                            // The find succeeded.
                            NSLog(@"Successfully retrieved %d objects.", objects.count);
                            Weapon *newWeapon = [[Weapon alloc]init];
                            for (int i = 0; i <= objects.count -1; i++) {
                                
                                PFObject *obj = [objects objectAtIndex:i];
                               
                                int wepID = [[obj valueForKey:@"wID"  ]integerValue];
                                NSString* wepName = [obj valueForKey:@"wName"  ];
                                int wepType =  [[obj valueForKey:@"wType"  ]integerValue];
                                int wepHands = [[obj valueForKey:@"wHands"  ]integerValue];
                                int wepDamage = [[obj valueForKey:@"wDamage" ]integerValue];
                                int wepQuant =  [[obj valueForKey:@"wQuantity"  ]integerValue];
                                NSString* wepParseID =  [obj objectId];
                                
                                [newWeapon setID: wepID];
                                [newWeapon setName: wepName];
                                [newWeapon setType: wepType];
                                [newWeapon setHands: wepHands];
                                [newWeapon setDamage: wepDamage];
                                [newWeapon setQuantity: wepQuant];
                                [newWeapon setParseID: wepParseID];
                                [weaponsArray addObject:newWeapon];

                                NSLog(@"Weapon ID %d", wepID);
                                NSLog(@"Weapon Name %@", wepName);
                                NSLog(@"Weapon Type %d", wepType);
                                NSLog(@"Weapon Hands %d", wepHands);
                                NSLog(@"Weapon Damage %d", wepDamage);
                                NSLog(@"Weapon Quantity %d", wepQuant);
                                NSLog(@"Weapon ParseID %@", wepParseID);
                                NSLog(@"ARRAY COUNT %d", [weaponsArray count] );
                                
                                NSString* lineIN = [NSString stringWithFormat:@"INSERT INTO weapons ( weaponID , name , type , hands , damage , quantity , parseID ) VALUES ( '%d', '%@', '%d', '%d', '%d', '%d', '%@')", wepID, wepName, wepType, wepHands, wepDamage, wepQuant, wepParseID ];
                                const char *insertStmnt = [lineIN UTF8String];
                                
                                sqlite3_stmt *compiledInStmnt;
                                
                                if (sqlite3_prepare_v2(dbcontext, insertStmnt, -1, &compiledInStmnt, NULL) == SQLITE_OK) {
                                    if (sqlite3_step(compiledInStmnt) == SQLITE_DONE) {
                                        sqlite3_finalize(compiledInStmnt);
                                    }
                                }else{
                                    NSLog(@"SQlite not ok.  Line 138");
                                }
                                sqlite3_close(dbcontext);
                                
                            }// end for loop
                            
                        } else {
                            // Log details of the failure
                            NSLog(@"Error: %@ %@", error, [error userInfo]);
                        }
                        
                    }];
                    
                }else{
                    
                    
                    NSLog(@"Data already populated to table");
                    
                }
            }
            sqlite3_close(dbcontext);
        } // end exec if
    } // end open if
} // end buildDB

- (IBAction)AddWeapon:(id)sender {
    AddWeapon *controller = [[AddWeapon alloc] initWithNibName:@"AddWeapon" bundle:nil];
    
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:controller animated:YES completion:nil];
    
}

//-(void)buildWeaponWithName :(NSString*) name withID :(int) wepID ofType: (int)type handsUsed :(int) hands doesDamage: (int) damage inStock :(int) quantity withParseID: (NSString*) parseID{
//    static sqlite3_stmt *insertStmt = nil;
//    insertStmt = "INSERT INTO weapons (name, weaponID, type, hands, damage, quantity, parseID) VALUES (?,?,?,?,?,?, ?)";
//    NSString * _name = name;
//    NSString * weapon = @"INSERT INTO weapons (name, weaponID, type, hands, damage, quantity, parseID) VALUES (\"%@\", %d, %d, %d, %d, %d, %@)",  name, [NSNumber numberWithInt: wepID], type, hands, damage, quantity, parseID;
//}
//
//
//-(void)insertDataintoDB{
//   NSLog(@"inserting data method");
//
//     const char *sql_stmt = "INSERT INTO weapons ( weaponID , name , type , hands , damage , quantity , parseID ) VALUES ( ?, ?, ?, ?, ?, ?, ?,)";
//    if(sqlite3_prepare_v2(dbcontext, insertStmt, -1, &compiledStatement, NULL) == SQLITE_OK)
//    {
//        sqlite3_bind_text(compiledStatement, 1, [productName UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_text(compiledStatement, 2, [regionName UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_text(compiledStatement, 3, [yearName UTF8String], -1, SQLITE_TRANSIENT);
//    }
//
//  //NSString * weapon = @"INSERT INTO weapons (name, weaponID, type, hands, damage, quantity, parseID) VALUES (?,?,?,?,?,?,?)",  name;
//  //  const char *weapon =  "INSERT INTO weapons (name, type, hands, damage, quantity, parseID) VALUES ('?', 1, 1, 25)";
////    const char *inSword2 =  "INSERT INTO weapons (name, type, hands, damage) VALUES ('Short Sword', 1, 1, 25)";
////    const char *inStar2 =      "INSERT INTO weapons (name, type, hands, damage) VALUES ('Pill Flail', 3, 2, 150)";
////    const char *inAxe2 =      "INSERT INTO weapons (name, type, hands, damage) VALUES ('Great Axe', 2, 2, 145)";
////    const char *inBow2 =     "INSERT INTO weapons (name, type, hands, damage) VALUES ('Longbow', 4, 2, 110)";
////    const char *inHatchet = "INSERT INTO weapons (name, type, hands, damage) VALUES ('Hatchet', 2, 1, 30)";
//
////    [self dbAutoFill:inSword2];
////    [self dbAutoFill:inStar2];
////    [self dbAutoFill:inAxe2];
////    [self dbAutoFill:inBow2];
////    [self dbAutoFill:inHatchet];
//
//
//    PFQuery *query = [PFQuery queryWithClassName:@"weaponsTablePARSE"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//
//            NSLog(@"Successfully retrieved %d objects.", objects.count);
//
//            for (int i = 0; i <= [objects count ] ; i ++) {
//                NSLog(@"Object %@", [objects valueForKey:@"wName"]);
//            }
//
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//        [spinner stopAnimating];
//        [load_message dismissWithClickedButtonIndex:0 animated:TRUE];
//
//    }];
//}

-(void)loadingSpinner{
    
    load_message = [[UIAlertView alloc] initWithTitle:@"Loading Catalog Data..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    spinner= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(135.0, 60.0);
    
    [load_message addSubview:spinner];  // Add a Spinner to the UIAlertView
    [load_message show];  // Show the Alert View
    [spinner startAnimating];  // Start the Spinner
    
    
    /////////  HOW TO STOP  ///////
    //    [spinner stopAnimating];
    //    [load_message dismissWithClickedButtonIndex:0 animated:TRUE];
    
}

-(void)dbAutoFill:(const char *)weaponIN{
    sqlite3_stmt *compileInsert;
    if(sqlite3_prepare_v2(dbcontext, weaponIN, -1, &compileInsert, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(compileInsert) == SQLITE_DONE){
            sqlite3_finalize(compileInsert);
            NSLog(@"Insert Done");
        }
    }else{
        NSLog(@"Insert Failed");
    }
}


////////  GO TO LIST VIEW  //////////////
- (IBAction)showInfo:(id)sender{
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    
    if (!selected) {
        controller.typeSelected = 0;
        controller.UTF8dbpath = UTF8dbpath;
    }else{
        controller.typeSelected = selected;
        controller.UTF8dbpath = UTF8dbpath;
    }
    NSLog(@"SELECTED: %d", selected);
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}


///////////// PICKER VIEW STUFF //////////////////////
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [typesArray objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [typesArray count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"SELECTED: %d", row);
    selected = row;
    
}
///////////////////////////////////////////////////////////////////////


@end
