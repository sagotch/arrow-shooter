//
//  Controller.h
//  shooter
//
//  Created by Julien Sagot on 25/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Character.h"
#import "Weapon.h"

enum direction {
    LEFT  = 0x1 << 1,
    RIGHT = 0x1 << 2,
    UP    = 0x1 << 3,
    DOWN  = 0x1 << 4
};

@interface CharacterController : NSObject
@property Character * character ;
-(instancetype) initWithCharacter:(Character *)character ;
-(void) keyDown:(int)keyCode ;
-(void) onKeyDown:(int)keyCode;
-(void) keyUp:(int)keyCode ;
-(void) onKeyUp:(int)keyCode;
@end

@interface HumanController : CharacterController
@property Human * character ;
@end

@interface GhostController : CharacterController
@property Ghost * character ;
@end

@interface WeaponController : NSObject
@property Weapon * weapon ;
-(instancetype) initWithWeapon :(Weapon *)weapon ;
-(void) mouseDown:(int)btnCode :(CGPoint)at ;
-(void) mouseUp:(int)btnCode :(CGPoint)at ;
@end

@interface BowController : WeaponController
@property Bow * weapon ;
@end
