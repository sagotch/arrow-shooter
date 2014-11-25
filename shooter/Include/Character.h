//
//  Character.h
//  shooter
//
//  Created by Julien Sagot on 17/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Collidable.h"
#import "Weapon.h"

enum direction {
    LEFT  = 0x1 << 1,
    RIGHT = 0x1 << 2,
    UP    = 0x1 << 3,
    DOWN  = 0x1 << 4
};

@interface Character : SKSpriteNode <Collidable>
@property float maxHealth ;
@property float health ;
@property float maxSpeed ;
@property Weapon * weapon ;
-(void) attackPoint :(CGPoint)point;
-(void) bleed ;
-(void) attackCharacter :(Character *)character ;
@end

// HUMANS //

@interface Human : Character
@property int contact ;
@end

@interface Hero : Human
@end


// GHOSTS //

@interface Ghost : Character
@end

@interface Enemy : Ghost
-(void)keepAttackingCharacter :(Character *)character ;
-(void)keepMovingInBounds :(float)xmin :(float)ymin :(float)xmax :(float)ymax;
@end
