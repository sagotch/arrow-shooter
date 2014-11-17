//
//  Landscape.m
//  shooter
//
//  Created by Julien Sagot on 17/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Landscape.h"
#import "BitMask.h"

@implementation Landscape

-(instancetype)initWithSize:(CGSize)size
{
    self = [super initWithColor:[NSColor blackColor] size:size];
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size] ;
    self.physicsBody.restitution = 0 ;
    self.physicsBody.friction = 0;
    self.physicsBody.dynamic = NO ;
    return self ;
}

@end

// Ground
@implementation Ground

-(instancetype)initWithWidth:(float)width
{
    self = [super initWithSize:CGSizeMake(width, 10)] ;
    self.physicsBody.categoryBitMask = GROUND ;
    return self;
}
@end

// Wall

@implementation Wall

-(instancetype)initWithHeight:(float)height
{
    self = [super initWithSize:CGSizeMake(10, height)] ;
    self.physicsBody.categoryBitMask = WALL ;
    return self ;
}

@end

// Trap
@implementation Trap

-(instancetype) initWithSize:(CGSize)size
{
    self = [super initWithSize:size] ;
    self.physicsBody.categoryBitMask = TRAP ;
    self.physicsBody.restitution = 1 ;
    self.damage = 10 ;
    return self ;
}

-(void)hitCharacter:(Character *)c
{
    c.health -= self.damage ;
    [c bleed] ;
}

-(void) activate
{
    [self runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:12. duration:1]]] ;
}

-(void) deactivate
{
    [self removeAllActions] ;
}
@end
