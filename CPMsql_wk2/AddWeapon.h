//
//  AddWeapon.h
//  CPMsql_wk2
//
//  Created by Shae Klusman on 5/26/13.
//  Copyright (c) 2013 Shae Klusman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddWeapon : UIViewController
{
    __weak IBOutlet UITextField *wepName;
    __weak IBOutlet UITextField *wepID;
    
    __weak IBOutlet UISegmentedControl *wepType;
    __weak IBOutlet UISegmentedControl *wepHands;
    __weak IBOutlet UITextField *wepDamage;
    __weak IBOutlet UITextField *wepQuantity;
}
- (IBAction)wepType:(id)sender;
- (IBAction)wepHands:(id)sender;

- (IBAction)submit:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)closeKeyboard:(id)sender;


@end
