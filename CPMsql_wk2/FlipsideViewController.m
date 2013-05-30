//
//  FlipsideViewController.m
//  CPMsql_wk2
//
//  Created by Shae Klusman on 5/16/13.
//  Copyright (c) 2013 Shae Klusman. All rights reserved.
//

#import "FlipsideViewController.h"
#import <sqlite3.h>
#import "customCell.h"
#import "AppDelegate.h"

@interface FlipsideViewController ()
{
    NSMutableArray *weaponArray;
    NSDictionary *wepDictionary;
    int count;
}
@end

@implementation FlipsideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    weaponArray = [[NSMutableArray alloc] init];
    NSLog(@"selection received: %d", _typeSelected);
    NSLog(@"filter received: %d", _filterSelected);
    [super viewDidLoad];
    [[self tableView]setDelegate:self];
    [[self tableView]setDataSource:self];
    [self getDBdata:_typeSelected filteredBy:_filterSelected];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

-(void)getDBdata:(int)selected filteredBy: (int)filter
{
    NSLog(@"PULLING DATA");
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
        NSString *thepath = [path objectAtIndex:0];
        NSString *dbName = @"weaponsDB.sqlite";
        dbPath = [thepath stringByAppendingPathComponent:dbName];
        const char *UTF8dbpath = [dbPath UTF8String];

        if (sqlite3_open(UTF8dbpath, &dbcontext) == SQLITE_OK)
        {
            // the DATABASE was opened successfully
            char *errMsg;
            const char *sql_stmt;
            int filterSet = ((_typeSelected +10) * (_filterSelected +1));
    
                switch (filterSet) {
                    case 10:
                        sql_stmt = "SELECT * FROM weapons";
                        break;
                    case 20:
                        sql_stmt = "SELECT * FROM weapons  ORDER BY weaponID";
                        break;
                    case 30:
                        sql_stmt = "SELECT * FROM weapons  ORDER BY name";
                        break;
                    case 40:
                        sql_stmt = "SELECT * FROM weapons  ORDER BY damage";
                        break;
                        
                        
                    case 11:
                        sql_stmt = "SELECT * FROM weapons WHERE type=1";
                        break;
                    case 22:
                        sql_stmt = "SELECT * FROM weapons WHERE type=1 ORDER BY weaponID";
                        break;
                    case 33:
                        sql_stmt = "SELECT * FROM weapons WHERE type=1 ORDER BY name";
                        break;
                    case 44:
                        sql_stmt = "SELECT * FROM weapons WHERE type=1 ORDER BY damage";
                    break;
                
                        
                    case 12:
                        sql_stmt = "SELECT * FROM weapons WHERE type=2";
                        break;
                    case 24:
                        sql_stmt = "SELECT * FROM weapons WHERE type=2 ORDER BY weaponID";
                        break;
                    case 36:
                        sql_stmt = "SELECT * FROM weapons WHERE type=2 ORDER BY name";
                        break;
                    case 48:
                        sql_stmt = "SELECT * FROM weapons WHERE type=2 ORDER BY damage";
                        break;
                        
                    case 13:
                        sql_stmt = "SELECT * FROM weapons";
                        break;
                    case 26:
                        sql_stmt = "SELECT * FROM weapons WHERE type=3 ORDER BY weaponID";
                        break;
                    case 39:
                        sql_stmt = "SELECT * FROM weapons WHERE type=3 ORDER BY name";
                        break;
                    case 52:
                        sql_stmt = "SELECT * FROM weapons WHERE type=3 ORDER BY damage";
                        break;
                        
                    case 14:
                        sql_stmt = "SELECT * FROM weapons";
                        break;
                    case 28:
                        sql_stmt = "SELECT * FROM weapons WHERE type=4 ORDER BY weaponID";
                        break;
                    case 42:
                        sql_stmt = "SELECT * FROM weapons WHERE type=4 ORDER BY name";
                        break;
                    case 56:
                        sql_stmt = "SELECT * FROM weapons WHERE type=4 ORDER BY damage";
                        break;
                        
                }
            
            if (sqlite3_exec(dbcontext, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                
            }
            sqlite3_stmt *statement;

            if( sqlite3_prepare_v2(dbcontext, sql_stmt, -1, &statement, NULL) == SQLITE_OK )
            {
                //Loop through all the returned rows
                while( sqlite3_step(statement) == SQLITE_ROW )
                {
                    count++;
                    //NSMutableArray *item = [[NSMutableArray alloc] init];
                    
                    NSString *ID = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 0)];
                    NSString *NAME = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 1)];
                    NSString *TYPE = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 2)];
                    NSString *HANDS = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 3)];
                    NSString *DAMAGE = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 4)];
                    NSDictionary *wepDict = [NSDictionary dictionaryWithObjectsAndKeys: ID, @"theID", NAME, @"theName", TYPE, @"theType", HANDS, @"theHands", DAMAGE, @"theDamage",nil];
                    [weaponArray addObject:wepDict];
                
                }
                NSLog(@"rows in FILTERED count %d", count);
                if (count == 0) {
                    NSLog(@"NO DATA FOR THIS TYPE");
                }
            }
            sqlite3_close(dbcontext);
        } // end exec if
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSUInteger section = [indexPath row];
    //NSString *key = [keys objectAtIndex:section];
    //NSArray *nameSection = [weaponArray objectAtIndex:section];

    
    static NSString *CellIdentifier = @"Cell";
    customCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"cell" owner:nil options:nil];
        
        for(id currentObject in cellArray)
        {
            if([currentObject isKindOfClass:[customCell class]])
            {
                cell = (customCell *)currentObject;
                NSDictionary *item = [weaponArray objectAtIndex:indexPath.row];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                // These lines add info to the Custom Cells
                cell._id.text = [item  objectForKey:@"theID"  ];
                cell._name.text = [item  objectForKey:@"theName"  ];
                cell._type.text = [item  objectForKey:@"theType"  ];
                cell._hands.text = [item  objectForKey:@"theHands"  ];
                cell._damage.text = [item  objectForKey:@"theDamage"  ];
                break;
            }
        }
    }
    // This line adds the little arrow at the end of each cell.
    
    return cell;

}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.areaSelection = [areaArray2 objectAtIndex:indexPath.row];  //send selection to delegate
//    NSLog(@" area selected = %@", [areaArray2 objectAtIndex:indexPath.row]);
//    
//    
//    
//    //[appDelegate buildEventData];
//    EventsViewController * newScreen = [[EventsViewController alloc] init];
//    [self.navigationController pushViewController:newScreen animated:YES];
}

@end
