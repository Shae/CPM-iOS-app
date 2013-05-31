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
#import "DeleteWeapon.h"
@interface MainViewController ()
{
    int selected;
    int filterSelected;
    const char *UTF8dbpath;
    UIActivityIndicatorView *spinner;
    UIAlertView* load_message;
    int countLocalTable;
    int viewAppeared;
    int parseCount;
}
@end

@implementation MainViewController

- (void)viewDidLoad{
    [Parse setApplicationId:@"KOHAaQRdCYXrO1RNBYF3iTSOoxrgTfXRsFUpMdhN"
                  clientKey:@"P3BgADyELTJe2ZyJFUs5cqabAagdVtg517VG2YHf"];
    viewAppeared = 0;
    countLocalTable = 0;
    weaponsArray = [[NSMutableArray alloc] init];
    
    typesArray = [[NSMutableArray alloc] init];
    [typesArray addObject:@"ALL TYPES"];
    [typesArray addObject:@"Sword"];
    [typesArray addObject:@"Axe"];
    [typesArray addObject:@"Blunt"];
    [typesArray addObject:@"Missile"];
    
    filterArray = [[NSMutableArray alloc] init];
    [filterArray addObject:@"No Filter"];
    [filterArray addObject:@"by ID"];
    [filterArray addObject:@"by Alpha"];
    [filterArray addObject:@"by Damage"];
    
    [self buildDB];
    [super viewDidLoad];
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
            
            if (sqlite3_exec(dbcontext, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
                NSLog(@" Created table if needed");
            }
            
            const char* countStmnt = "SELECT * FROM weapons";
            sqlite3_stmt *statement;
            
            if( sqlite3_prepare_v2(dbcontext, countStmnt, -1, &statement, NULL) == SQLITE_OK )
            {
                //Loop through all the returned rows
                while( sqlite3_step(statement) == SQLITE_ROW )
                {
                    countLocalTable++;
                }
                NSLog(@"Local table row count %d", countLocalTable);
                
                //  check to see if table needs populated
                if (countLocalTable == 0) {
                    NSLog(@"Local count 0 populating data from parse");
                    // populate local table with Parse Data;
                    [self populate];
                }
                
            }
            sqlite3_close(dbcontext);
        } // end exec if
    } // end open if
} // end buildDB

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@" *** VIEW APPEARED***");
    
    if (viewAppeared == 0) {
        NSLog(@" *** VIEW HAS APPEARED %d TIMES***", viewAppeared);
        //[self countParseDB];
    }else{
        NSLog(@" *** VIEW APPEARED AGAIN*** %d", viewAppeared);
        [self localDBCount];
        PFQuery *query = [PFQuery queryWithClassName:@"weaponsTablePARSE"];
        [query whereKeyExists:@"wName"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Parse has %d items: Local has %d", objects.count, countLocalTable);
                parseCount = objects.count;
                NSLog(@"local count %d: (out)", countLocalTable);
                [self DB_EqualCheck];
            } else {

                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } // END if error
        }];  
    }// end else appeared
}

-(void)DB_EqualCheck{  // Used after parse count and return
    if (countLocalTable == parseCount) {
        NSLog(@" The counts are Equal.  Local %d, Parse %d",countLocalTable,  parseCount);
        
    }else{
        NSLog(@" The counts are NOT Equal.  Local %d.  Parse %d.",countLocalTable,  parseCount);
        
        if (viewAppeared == 0) {
            
            NSLog(@"NEEDS SYNC - AUTO");
            [self deleteDbRows];
            [self buildDB];
        }else{
            updateBtn.hidden = !updateBtn.hidden;
            NSLog(@"NEEDS SYNC - MANUAL");
             UIAlertView *update_message = [[UIAlertView alloc] initWithTitle:@"Catalog Update Available" message:@"Click the PLUS button in the upper right corner to update." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
            [update_message show];
        }
        
    } //END if equal
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)countParseDB{
    PFQuery *query = [PFQuery queryWithClassName:@"weaponsTablePARSE"];
    [query whereKeyExists:@"wName"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Parse has %d items", objects.count);
            parseCount = objects.count;
            _localDBCount = parseCount;
            [self DB_EqualCheck];
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } // END if error
    }];
}  // END countParse

-(void)populate{
    [self loadingSpinner];
    ////////////////  ADD DATA INTO DB
    NSLog(@"Calling for table Population");
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
                

                NSLog(@" %@ added to weaponsArray", wepName);
                NSLog(@"ARRAY COUNT %d", [weaponsArray count] );
                countLocalTable = [weaponsArray count];
                
                NSString* lineIN = [NSString stringWithFormat:@"INSERT INTO weapons ( weaponID , name , type , hands , damage , quantity , parseID ) VALUES ( '%d', '%@', '%d', '%d', '%d', '%d', '%@')", wepID, wepName, wepType, wepHands, wepDamage, wepQuant, wepParseID ];
                const char *insertStmnt = [lineIN UTF8String];
                
                sqlite3_stmt *compiledInStmnt;
                
                if (sqlite3_prepare_v2(dbcontext, insertStmnt, -1, &compiledInStmnt, NULL) == SQLITE_OK) {
                    if (sqlite3_step(compiledInStmnt) == SQLITE_DONE) {
                        sqlite3_finalize(compiledInStmnt);
                        NSLog(@"%@ insert into local DB", wepName);
                    }
                }else {
                    NSLog(@"SQlite not ok. ");
                }
            }// end for loop
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [spinner stopAnimating];
        [load_message dismissWithClickedButtonIndex:0 animated:TRUE];
    }];
    
}

-(void)countLocal{
    countLocalTable = 0;
    NSLog(@"Count local");
    
                   sqlite3_close(dbcontext);
                   const char* countStmnt = "SELECT * FROM weapons";
                    sqlite3_stmt *statement;
    
                    if( sqlite3_prepare_v2(dbcontext, countStmnt, -1, &statement, NULL) == SQLITE_OK )
                    {
                        //Loop through all the returned rows
                       while( sqlite3_step(statement) == SQLITE_ROW )
                       {
                           countLocalTable++;
                        }
                        NSLog(@"Local table row count %d", countLocalTable);
   
                    }

}

- (IBAction)AddWeapon:(id)sender {
    viewAppeared++;
    AddWeapon *controller = [[AddWeapon alloc] initWithNibName:@"AddWeapon" bundle:nil];
    
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (IBAction)Update:(id)sender {
    NSLog(@"UPDATING DATA");
    [self deleteDbRows];
    [self populate];
    updateBtn.hidden = TRUE;
}

-(void)deleteDbRows{
    UTF8dbpath = [dbPath UTF8String];
    if (sqlite3_open(UTF8dbpath, &dbcontext) == SQLITE_OK){
        NSLog(@"Deleting all rows");
        NSString* DeleteStmnt = [NSString stringWithFormat:@"DELETE FROM weapons"];
        const char *convDeleteStmnt = [ DeleteStmnt UTF8String];
        sqlite3_stmt *stmnt;
        
        if (sqlite3_prepare_v2(dbcontext, convDeleteStmnt, -1, &stmnt, NULL) == SQLITE_OK) {
           
            while(sqlite3_step(stmnt) == SQLITE_ROW) {
                // Read the data from the result row
                NSLog(@"deleting row");
            }
             sqlite3_finalize(stmnt);
            NSLog(@"ROWs Dropped");
        }
        sqlite3_close(dbcontext);
    }else{
        NSLog(@"sqlite_open for deleteDbRows failed");
    }
    NSLog(@"Deleting all rows DONE");
    [self buildDB];
}

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
    viewAppeared++;
    
    NSLog(@"local count %d: (out)", countLocalTable);
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.typeSelected = [pickerView selectedRowInComponent:0];
    controller.filterSelected = [pickerView selectedRowInComponent:1];
    controller.UTF8dbpath = UTF8dbpath;

    NSLog(@"SELECTED Filter: %d", [pickerView selectedRowInComponent:0]);
    NSLog(@"SELECTED Sort: %d", [pickerView selectedRowInComponent:1]);
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)DeleteWeapon:(id)sender {


    viewAppeared++;
    DeleteWeapon *controller = [[DeleteWeapon alloc] initWithNibName:@"DeleteWeapon" bundle:nil];
    if (weaponsArray.count > 0) {
        NSLog(@"weapons array count %d", weaponsArray.count );
    }else{
        NSLog(@"weapons array empty");
    }
    //controller.weaponsArray = weaponsArray;
    //controller.UTF8dbpath = UTF8dbpath;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:controller animated:YES completion:nil];
    
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}
///////////// PICKER VIEW STUFF //////////////////////
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [typesArray objectAtIndex:row];
    }else{
        return [filterArray objectAtIndex:row];
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return [typesArray count];
    }else{
        return [filterArray count];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    
    
}
///////////////////////////////////////////////////////////////////////


@end
