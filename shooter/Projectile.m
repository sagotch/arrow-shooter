//
//  Projectile.m
//  shooter
//
//  Created by Julien Sagot on 17/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Projectile.h"
#import "BitMask.h"
#import "Character.h"

@implementation Projectile

-(instancetype)initWithColor:(NSColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size] ;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size] ;
    self.damage = 0 ;
    return self ;
}

-(void)hitCharacter:(Character *)c
{
    c.health -= self.damage ;
}

-(void)fire :(CGPoint)from :(CGVector)toward
{
    self.position = from ;
    self.physicsBody.velocity = toward ;
}

@end

// Arrow
@implementation Arrow
-(instancetype)init
{
    self = [super initWithColor:[NSColor blueColor] size:CGSizeMake(10, 10)] ;
    self.physicsBody.dynamic = YES ;
    self.physicsBody.categoryBitMask = ARROW ;
    self.physicsBody.collisionBitMask = GROUND | ARROW | ENEMY | WALL ;
    self.physicsBody.contactTestBitMask = GROUND | ARROW | ENEMY | WALL ;
    self.damage = 5 ;
    return self ;
}
@end

// FireBall
@implementation FireBall
-(instancetype)init
{
    self = [super initWithColor:[NSColor redColor] size:CGSizeMake(10, 10)] ;
    self.physicsBody.dynamic = YES ;
    self.physicsBody.affectedByGravity = NO ;
    self.physicsBody.categoryBitMask = FIREBALL ;
    self.physicsBody.collisionBitMask = HERO ;
    self.physicsBody.contactTestBitMask = HERO ;
    self.damage = 15 ;
    return self ;
}
@end
