//
//  Projectile.h
//  shooter
//
//  Created by Julien Sagot on 17/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Collidable.h"
@class Character ;

@interface Projectile : SKSpriteNode <Collidable>
@property float damage ;
@property NSString * soundHit ;
@property NSString * soundFire ;
-(void) fire :(CGPoint)from :(CGVector)toward ;
-(void) hitCharacter :(Character *)c ;
@end

@interface Arrow : Projectile
-(instancetype)init ;
@end

@interface FireBall : Projectile
-(instancetype)init ;
@end
