//
//  DeleteWeapon.m
//  CPMsql_wk2
//
//  Created by Shae Klusman on 5/30/13.
//  Copyright (c) 2013 Shae Klusman. All rights reserved.
//

#import "DeleteWeapon.h"
#import <Parse/Parse.h>
#import <sqlite3.h>

@interface DeleteWeapon ()

@end

@implementation DeleteWeapon
@synthesize weaponsArray;

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
    
    [Parse setApplicationId:@"KOHAaQRdCYXrO1RNBYF3iTSOoxrgTfXRsFUpMdhN"
                  clientKey:@"P3BgADyELTJe2ZyJFUs5cqabAagdVtg517VG2YHf"];
    weaponsArray = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view from its nib.
    
//    PFQuery *query = [PFQuery queryWithClassName:@"weaponsTablePARSE"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %d objects.", objects.count);
//
//            for (int i = 0; i <= objects.count -1; i++) {
//                
//                PFObject *obj = [objects objectAtIndex:i];
//                
//               // int wepID = [[obj valueForKey:@"wID"  ]integerValue];
//                NSString* wepName = [obj valueForKey:@"wName"  ];
//               // int wepType =  [[obj valueForKey:@"wType"  ]integerValue];
//                //int wepHands = [[obj valueForKey:@"wHands"  ]integerValue];
//                //int wepDamage = [[obj valueForKey:@"wDamage" ]integerValue];
//                //int wepQuant =  [[obj valueForKey:@"wQuantity"  ]integerValue];
//               // NSString* wepParseID =  [obj objectId];
//                
//                [weaponsArray addObject:wepName];
//                
//
//            }// end for loop
//           
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }

//    }];
 [super viewDidLoad];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
    NSString *thepath = [path objectAtIndex:0];
    NSString *dbName = @"weaponsDB.sqlite";
    dbPath = [thepath stringByAppendingPathComponent:dbName];
    NSLog(@"Database Path= %@", dbPath);
    UTF8dbpath = [dbPath UTF8String];
    
    if (sqlite3_open(UTF8dbpath, &dbcontext) == SQLITE_OK)
    {

    const char* Stmnt = "SELECT * FROM weapons";
    sqlite3_stmt *statement;
    
    if( sqlite3_prepare_v2(dbcontext, Stmnt, -1, &statement, NULL) == SQLITE_OK ){
        //Loop through all the returned rows
        while( sqlite3_step(statement) == SQLITE_ROW ){
        NSString *ID = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 0)];
          NSString *NAME = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 1)];
            NSString *TYPE = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 2)];
           NSString *HANDS = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 3)];
            NSString *DAMAGE = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 4)];
            NSString *PARSEID = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 6)];
           NSDictionary *wepDict = [NSDictionary dictionaryWithObjectsAndKeys: ID, @"theID", NAME, @"theName", TYPE, @"theType", HANDS, @"theHands", DAMAGE, @"theDamage", PARSEID, @"theParseID", nil];
            [weaponsArray addObject:wepDict];
            NSLog(@"Array count %d", [weaponsArray count]);

        }

    }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Done:(id)sender {
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)Delete:(id)sender {
    int sel = [pickerView selectedRowInComponent:0];
    NSString * name = [[weaponsArray objectAtIndex:sel] valueForKey:@"theName"];
    NSString * parID = [[weaponsArray objectAtIndex:sel] valueForKey:@"theParseID"];
    NSLog(@" PLEASE DELETE THIS: %@ KEY: %@", name, parID);
    NSString * del = [NSString stringWithFormat:@"Are you sure you want to delete %@ from the catalog?", name];
    UIAlertView *delete_message = [[UIAlertView alloc] initWithTitle:@"Delete Weapon" message:del  delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [delete_message show];

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Cancel"])
    {
        NSLog(@"CANCELED.");
    }
    else if([title isEqualToString:@"Yes"])
    {
        NSLog(@"Delete Approved");
        int sel = [pickerView selectedRowInComponent:0];
        NSString * parID = [[weaponsArray objectAtIndex:sel] valueForKey:@"theParseID"];
        PFQuery *query = [PFQuery queryWithClassName:@"weaponsTablePARSE"];
        PFObject *obj = [query getObjectWithId:parID];
        [obj deleteEventually];
    }

}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    return [[weaponsArray objectAtIndex:row ]valueForKey:@"theName"];

    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return [weaponsArray count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

}
@end
