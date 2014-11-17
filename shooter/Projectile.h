//
//  Projectile.h
//  shooter
//
//  Created by Julien Sagot on 17/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Character.h"

@interface Projectile : SKSpriteNode
@property float damage ;
-(void) fire :(CGPoint)from :(CGVector)toward;
-(void)hitCharacter:(Character *)c ;
@end

@interface Arrow : Projectile
-(instancetype)init ;
@end

@interface FireBall : Projectile
-(instancetype)init ;
@end
