//
//  FlipsideViewController.h
//  CPMsql_wk2
//
//  Created by Shae Klusman on 5/16/13.
//  Copyright (c) 2013 Shae Klusman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weapon.h"
#import "sqlite3.h"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *weaponsArray;
        NSString *dbPath;
        sqlite3 *dbcontext;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int typeSelected;
@property (nonatomic) int filterSelected;
@property (nonatomic)  const char UTF8dbpath;
@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;


@end
