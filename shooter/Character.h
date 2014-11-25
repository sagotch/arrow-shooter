//
//  Character.h
//  shooter
//
//  Created by Julien Sagot on 17/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Projectile ;

@interface Character : SKSpriteNode
@property float maxHealth ;
@property float health ;
@property float maxSpeed ;
-(void) attackPoint:(CGPoint)point;
-(void) bleed ;
-(void) attackCharacter:(Character *)character ;
-(void) throwProjectile:(Projectile *)projectile withForce:(float)force toward:(CGPoint)point ;

-(void) mouseDown:(int)btnCode :(CGPoint)at ;
-(void) mouseUp:(int)btnCode :(CGPoint)at ;
@end

// HUMANS //

@interface Human : Character
@property int contact ;
@end

@interface Hero : Human
@property NSDate* chargeStart ;
-(void) charge ;
@end


// GHOSTS //

@interface Ghost : Character
@end

@interface Enemy : Ghost
-(void)keepAttackingCharacter:(Character *)character ;
-(void)keepMovingInBounds:(float)xmin :(float)ymin :(float)xmax :(float)ymax;
@end
