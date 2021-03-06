//
//  Character.m
//  shooter
//
//  Created by Julien Sagot on 17/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import "Character.h"
#import "Weapon.h"
#import "Landscape.h"
#import "PowerUp.h"

@implementation Character

-(instancetype)initWithColor:(NSColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size] ;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size] ;
    return self ;
}

-(void) bleed
{
    [self runAction:[SKAction repeatAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0 duration:0.1],
                                                                [SKAction fadeAlphaTo:1 duration:0.1]]] count:3]] ;
}

@end

// Hero

@implementation Human
-(instancetype)initWithColor:(NSColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size] ;
    self.physicsBody.dynamic = YES ;
    self.physicsBody.allowsRotation = NO ;
    self.physicsBody.restitution = 0 ;
    self.physicsBody.friction = 0 ;
    self.physicsBody.categoryBitMask = SOLID ;
    self.physicsBody.collisionBitMask = LANDSCAPE ;
    self.physicsBody.contactTestBitMask = 0 ;
    self.contact = 0 ;
    return self ;
}

@end

@implementation Hero

-(instancetype)init
{
    self = [super initWithColor:[NSColor blueColor] size:CGSizeMake(50, 75)] ;
    self.physicsBody.categoryBitMask |= ALLY ;
    self.maxHealth = 100 ;
    self.health = self.maxHealth ;
    self.maxSpeed = 500 ;
    return self ;
}

-(void) didBeginContactWithBody:(SKNode<Collidable> *)b
{
    if (b.physicsBody.categoryBitMask & LANDSCAPE)
    {
        self.contact += 1 ;
    }
}

-(void) didEndContactWithBody:(SKNode<Collidable> *)b
{
    if (b.physicsBody.categoryBitMask & LANDSCAPE)
    {
        self.contact -= 1;
    }
}

@end

@implementation Ghost
-(instancetype) initWithColor:(NSColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size] ;
    self.physicsBody.dynamic = NO ;
    self.physicsBody.categoryBitMask = MAGICAL ;
    self.physicsBody.collisionBitMask = 0 ;
    self.physicsBody.contactTestBitMask = 0 ;
    return self ;
}

@end

@implementation Enemy
-(instancetype)init
{
    self = [super initWithColor:[NSColor redColor] size:CGSizeMake(50, 50)] ;
    self.physicsBody.categoryBitMask |= ENEMY ;
    self.maxHealth = 100 ;
    self.health = self.maxHealth ;
    return self ;
}

-(void)keepMovingInBounds:(float)xmin :(float)ymin :(float)xmax :(float)ymax
{
    [self runAction:
     [SKAction repeatActionForever:
      [SKAction sequence:
       @[[SKAction waitForDuration:1],
         [SKAction runBlock:^{
          int x = arc4random_uniform(xmax - xmin);
          int y = arc4random_uniform(ymax - ymin);
          [self runAction: [SKAction moveTo:CGPointMake(xmin + x, ymin + y) duration:1]];}],
         [SKAction waitForDuration:1]]
       ]
      ]
     ];
}

-(void)keepAttackingCharacter:(Character *)character
{
    [self runAction:
     [SKAction sequence:
      @[[SKAction repeatAction:
         [SKAction sequence:
          @[[SKAction waitForDuration:self.health / 100],
            [SKAction runBlock:^{[self.weapon fireToward:character.position];}]
            ]
          ]
                         count:(10 - self.health / 20)
         ],
        [SKAction waitForDuration:1]
        ]
      ]
         completion:^{[self keepAttackingCharacter:character] ;}
     ];
}

@end

