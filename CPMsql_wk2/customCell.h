//
//  customCell.h
//  CPMsql_wk2
//
//  Created by Shae Klusman on 5/16/13.
//  Copyright (c) 2013 Shae Klusman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *_name;
@property (weak, nonatomic) IBOutlet UILabel *_id;
@property (weak, nonatomic) IBOutlet UILabel *_damage;
@property (weak, nonatomic) IBOutlet UILabel *_type;
@property (weak, nonatomic) IBOutlet UILabel *_hands;

@end
