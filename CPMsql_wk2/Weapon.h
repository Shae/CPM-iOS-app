//
//  Weapon.h
//  CPMsql_wk2
//
//  Created by Shae Klusman on 5/16/13.
//  Copyright (c) 2013 Shae Klusman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weapon : NSObject
{
    int _id;
    NSString *_name;
    int _type;
    int _hands;
    int _damage;
    int _quantity;
    NSString * _parseID;
}
@property (assign) int _id;
@property (strong, nonatomic) NSString* _name;
@property (assign) int _type;
@property (assign) int _hands;
@property (assign) int _damage;
@property (assign) int _quantity;
@property (strong, nonatomic) NSString* _parseID;

-(void)setName:(NSString *)name;

-(NSString*)getName;

//////////////

-(void)setID:(int)ID;

-(int)getID;

/////////////////

-(void)setType:(int)wepType;

-(int)getType;
//////////////

-(void)setHands:(int)Hands;

-(int)getHands;

//////////////

-(void)setDamage:(int)Damage;

-(int)getDamage;

//////////////

-(void)setQuantity:(int)Quantity;

-(int)getQuantity;

//////////////

-(void)setParseID:(NSString*)parseID;

-(NSString*)getParseID;


@end
