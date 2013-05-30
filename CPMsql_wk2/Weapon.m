//
//  Weapon.m
//  CPMsql_wk2
//
//  Created by Shae Klusman on 5/16/13.
//  Copyright (c) 2013 Shae Klusman. All rights reserved.
//

#import "Weapon.h"

@implementation Weapon
@synthesize _id, _name, _hands, _type, _damage, _quantity, _parseID;
- (id)init
{
    self = [super init];
    if (self) {
        _id = 0000;
        _name = @"Default";
        _type = 1;
        _hands = 0;
        _damage = 0;
        _quantity = 0;
        
    }
    return self;
}

///////////////
-(void)setName:(NSString *)name{
    _name = name;
}

-(NSString*)getName{
    return _name;
}

//////////////

-(void)setID:(int)ID{
    _id = ID;
}

-(int)getID{
    return _id;
}

/////////////////

-(void)setType:(int)wepType{
    _type = wepType;
}

-(int)getType{
    return _type;
}

//////////////

-(void)setHands:(int)Hands{
    _hands = Hands;
}

-(int)getHands{
    return _hands;
}

//////////////

-(void)setDamage:(int)Damage{
    _damage = Damage;
}

-(int)getDamage{
    return _damage;
}

//////////////

-(void)setQuantity:(int)Quantity{
    _quantity= Quantity;
}

-(int)getQuantity{
    return _quantity;
}

//////////////

-(void)setParseID:(NSString*)parseID{
    _parseID = parseID;
}

-(NSString*)getParseID{
    return _parseID;
}

/////////////////

@end
