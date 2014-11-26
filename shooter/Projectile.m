//
//  Projectile.m
//  shooter
//
//  Created by Julien Sagot on 17/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Projectile.h"
#import "Character.h"

@implementation Projectile

-(instancetype)initWithTarget :(int)target Color:(NSColor *)color Size:(CGSize)size
{
    self = [super initWithColor:color size:size] ;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size] ;
    self.physicsBody.categoryBitMask = 0 ;
    self.targetBitMask = target ;
    self.physicsBody.collisionBitMask = target ;
    self.physicsBody.contactTestBitMask = target ;
    self.damage = 0 ;
    self.soundHit = @"arrow-hit.wav";
    return self ;
}

-(void)hitCharacter:(Character *)c
{
    [self.parent runAction:[SKAction playSoundFileNamed:self.soundHit waitForCompletion:YES]] ;
    c.health -= self.damage ;
    [c bleed] ;
}

-(void)fire :(CGPoint)from :(CGVector)toward
{
    self.position = from ;
    self.physicsBody.velocity = toward ;
    [self runAction:[SKAction playSoundFileNamed:self.soundFire waitForCompletion:NO]] ;
}

-(void) didBeginContactWithBody:(SKNode<Collidable> *)b
{
    if (b.physicsBody.categoryBitMask & self.targetBitMask)
    {
        [self hitCharacter:(Character *)b] ;
        [self removeFromParent] ;
    }
}

@end

// Arrow
@implementation Arrow
-(instancetype)initWithTarget :(int)target
{
    self = [super initWithTarget:target Color:[NSColor blueColor] Size:CGSizeMake(10, 10)] ;
    self.physicsBody.dynamic = YES ;
    self.physicsBody.categoryBitMask = SOLID ;
    self.physicsBody.collisionBitMask = LANDSCAPE ;
    self.damage = 5 ;
    self.soundFire = @"arrow-fire.wav" ;
    return self ;
}

-(void) didBeginContactWithBody:(SKNode<Collidable> *)b
{
    if (b.physicsBody.categoryBitMask & ENEMY)
    {
        [self hitCharacter:(Character *)b] ;
        [self removeFromParent] ;
    }
}

@end

// FireBall
@implementation FireBall
-(instancetype)initWithTarget:(int)target
{
    self = [super initWithTarget:target Color:[NSColor redColor] Size:CGSizeMake(10, 10)] ;
    self.physicsBody.dynamic = YES ;
    self.physicsBody.affectedByGravity = NO ;
    self.physicsBody.categoryBitMask = MAGICAL ;
    self.damage = 15 ;
    self.soundFire = @"fireball-fire.wav" ;
    return self ;
}

@end
