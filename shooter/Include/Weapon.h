//
//  Weapon.h
//  shooter
//
//  Created by Julien Sagot on 25/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Projectile.h"

@interface Weapon : SKSpriteNode
-(void) fireToward :(CGPoint)point ;
@end

@interface Bow : Weapon
@property NSDate * chargeStart ;
-(void) charge ;
@end

@interface FireBallLauncher : Weapon
@end