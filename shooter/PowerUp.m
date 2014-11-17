//
//  PowerUp.m
//  shooter
//
//  Created by Julien Sagot on 17/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import "PowerUp.h"
#import "BitMask.h"
#import "Character.h"

@implementation PowerUp

-(instancetype)initWithSize:(CGSize)size
{
    self = [super initWithColor:[NSColor greenColor] size:size];
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size] ;
    self.physicsBody.categoryBitMask = POWERUP ;
    self.physicsBody.contactTestBitMask = HERO ;
    self.physicsBody.collisionBitMask = HERO ;
    self.physicsBody.dynamic = NO ;
    return self ;
}

@end

@implementation HealthPack

-(instancetype)init
{
    self = [super initWithSize:CGSizeMake(25, 25)] ;
    self.soundPowerUp = @"healthpack-powerup.wav" ;
    return self ;
}

-(void)powerUpCharacter:(Character *)c
{
    [self.parent runAction:[SKAction playSoundFileNamed:self.soundPowerUp waitForCompletion:NO]] ;
    c.health = MIN(c.health + 10, c.maxHealth);
}


@end