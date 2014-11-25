//
//  Character.h
//  shooter
//
//  Created by Julien Sagot on 17/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Weapon.h"

@interface Character : SKSpriteNode
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
