//
//  MainViewController.h
//  CPMsql_wk2
//
//  Created by Shae Klusman on 5/16/13.
//  Copyright (c) 2013 Shae Klusman. All rights reserved.
//

#import "FlipsideViewController.h"
#import "DeleteWeapon.h"
#import <sqlite3.h>
#import "Weapon.h"
#import <CoreData/CoreData.h>


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *weaponsArray;
    NSMutableArray *filterArray;
     NSMutableArray *typesArray;
    NSString *dbPath;
    sqlite3 *dbcontext;
    __weak IBOutlet UIButton *updateBtn;
    __weak IBOutlet UIPickerView *pickerView;
}

@property (weak, nonatomic) IBOutlet UIButton *goBtn;
@property (nonatomic) int localDBCount;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (IBAction)AddWeapon:(id)sender;
- (IBAction)Update:(id)sender;
- (IBAction)showInfo:(id)sender;
- (IBAction)DeleteWeapon:(id)sender;


@end
