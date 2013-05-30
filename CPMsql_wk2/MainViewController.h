//
//  MainViewController.h
//  CPMsql_wk2
//
//  Created by Shae Klusman on 5/16/13.
//  Copyright (c) 2013 Shae Klusman. All rights reserved.
//

#import "FlipsideViewController.h"
#import <sqlite3.h>
#import "Weapon.h"
#import <CoreData/CoreData.h>


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *weaponsArray;
     NSMutableArray *typesArray;
    NSString *dbPath;
    sqlite3 *dbcontext;
    __weak IBOutlet UIPickerView *pickerView;
}

@property (weak, nonatomic) IBOutlet UIButton *goBtn;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (IBAction)AddWeapon:(id)sender;


//-(void)insertDataintoDB;
- (IBAction)showInfo:(id)sender;
//-(void)buildWeaponWithName :(NSString*) name
//                 withID :(int) wepID
//                 ofType: (int)type
//                 handsUsed :(int) hands
//                 doesDamage: (int) damage
//                 inStock :(int) quantity
//                 withParseID: (NSString*) parseID;

@end
