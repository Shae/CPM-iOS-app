//
//  DeleteWeapon.h
//  CPMsql_wk2
//
//  Created by Shae Klusman on 5/30/13.
//  Copyright (c) 2013 Shae Klusman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface DeleteWeapon : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>
{
    NSMutableArray *weaponsArray;
    __weak IBOutlet UIPickerView *pickerView;
    NSString *dbPath;
    sqlite3 *dbcontext;
    NSString* selectionName;
     const char *UTF8dbpath;
}
@property (nonatomic) NSMutableArray *weaponsArray;
- (IBAction)Done:(id)sender;
- (IBAction)Delete:(id)sender;

@end
