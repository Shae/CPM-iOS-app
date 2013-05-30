//
//  AddWeapon.m
//  CPMsql_wk2
//
//  Created by Shae Klusman on 5/26/13.
//  Copyright (c) 2013 Shae Klusman. All rights reserved.
//

#import "AddWeapon.h"
#import <Parse/Parse.h>
#import "MainViewController.h"

@interface AddWeapon ()

@end

@implementation AddWeapon

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
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)wepType:(id)sender {
}

- (IBAction)wepHands:(id)sender {
}

- (IBAction)submit:(id)sender {
    NSString* _name = wepName.text;
    int _id = [wepID.text integerValue];
    int  _type = (wepType.selectedSegmentIndex + 1) ;
    int _hands = (wepHands.selectedSegmentIndex + 1);
    int _damage = [wepDamage.text integerValue];
    int _quantity = [wepQuantity.text integerValue];
    [self parseSaveNewWeaponWithName:_name withType:_type withID:_id numberHands:_hands doesDamage:_damage numberInStock:_quantity];
}

- (IBAction)back:(id)sender {
   [self dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)closeKeyboard:(id)sender {
    [wepDamage resignFirstResponder];
    [wepID resignFirstResponder];
    [wepName resignFirstResponder];
    [wepQuantity resignFirstResponder];

}


-(void) parseSaveNewWeaponWithName: (NSString *) name withType:(int) type withID: (int)ID numberHands: (int) hands doesDamage: (int)damage numberInStock: (int)quantity
{
    
        
    NSLog(@"Creating New Weapon %@", name);
    PFObject *newWeapon = [PFObject objectWithClassName:@"weaponsTablePARSE"];
    [newWeapon setObject:[NSNumber numberWithInt:damage] forKey:@"wDamage"];
    [newWeapon setObject:[NSNumber numberWithInt:hands] forKey:@"wHands"];
    [newWeapon setObject:name forKey:@"wName"];
    [newWeapon setObject:[NSNumber numberWithInt:quantity]forKey:@"wQuantity"];
    [newWeapon setObject:[NSNumber numberWithInt:type] forKey:@"wType"];
    [newWeapon setObject:[NSNumber numberWithInt:ID]forKey:@"wID"];
    
    [newWeapon saveInBackground];
}

@end
