//
//  InfoViewController.h
//  CPMsql_wk2
//
//  Created by Shae Klusman on 5/25/13.
//  Copyright (c) 2013 Shae Klusman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController
{
    NSMutableArray *wepArray;
}
@property (weak, nonatomic) IBOutlet UILabel *wepName;
@property (weak, nonatomic) IBOutlet UILabel *wepHands;
@property (weak, nonatomic) IBOutlet UILabel *wepDam;
@property (weak, nonatomic) IBOutlet UILabel *wepStock;
@property (weak, nonatomic) IBOutlet UILabel *wepID;
@property (weak, nonatomic) IBOutlet UILabel *wepType;

- (IBAction)purchaseBTN:(id)sender;
- (IBAction)doneBTN:(id)sender;

@end
