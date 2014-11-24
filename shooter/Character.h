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

-(void) keyDown:(int)keyCode ;
-(void) keyUp:(int)keyCode ;
-(void) mouseDown:(int)btnCode :(CGPoint)at ;
-(void) mouseUp:(int)btnCode :(CGPoint)at ;
@end

@interface Hero : Character
@property int contact ;
@property NSDate* chargeStart ;
-(void) charge ;
@end

@interface Enemy : Character
-(void)keepAttackingCharacter:(Character *)character ;
-(void)keepMovingInBounds:(float)xmin :(float)ymin :(float)xmax :(float)ymax;
@end
