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

-(instancetype)initWithColor:(NSColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size] ;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size] ;
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

@end

// Arrow
@implementation Arrow
-(instancetype)init
{
    self = [super initWithColor:[NSColor blueColor] size:CGSizeMake(10, 10)] ;
    self.physicsBody.dynamic = YES ;
    self.physicsBody.categoryBitMask = ARROW ;
    self.physicsBody.collisionBitMask = ENEMY ;
    self.physicsBody.contactTestBitMask = ENEMY ;
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

-(void)hitCharacter:(Character *)c
{
    [super hitCharacter:c] ;
}

-(void)fire:(CGPoint)from :(CGVector)toward
{
    [super fire:from :toward];
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
    self.soundFire = @"fireball-fire.wav" ;
    return self ;
}

-(void)hitCharacter:(Character *)c
{
    [super hitCharacter:c] ;
}

-(void)fire:(CGPoint)from :(CGVector)toward
{
    [super fire:from :toward];
}
@end
