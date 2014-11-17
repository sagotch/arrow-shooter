//
//  Character.m
//  shooter
//
//  Created by Julien Sagot on 17/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import "Character.h"
#import "CGVectorAdditions.h"
#import "Projectile.h"
#import "BitMask.h"

@implementation Character

-(instancetype)initWithColor:(NSColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size] ;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size] ;
    return self ;
}

-(void)throwProjectile:(Projectile *)projectile withForce:(float)force toward:(CGPoint)point
{
    CGVector v = CGVectorMake(point.x - self.position.x, point.y - self.position.y) ;
    v = CGVectorMultiplyByScalar(CGVectorNormalize(v), force) ;
    [projectile fire:self.position :v] ;
    [self.parent addChild:projectile] ;
}

-(void) bleed
{
    [self runAction:[SKAction repeatAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0 duration:0.1],
                                                                [SKAction fadeAlphaTo:1 duration:0.1]]] count:3]] ;
}

@end

// Hero

@implementation Hero

-(instancetype)init
{
    self = [super initWithColor:[NSColor blueColor] size:CGSizeMake(50, 75)] ;
    self.physicsBody.dynamic = YES ;
    self.physicsBody.allowsRotation = NO ;
    self.physicsBody.restitution = 0 ;
    self.physicsBody.categoryBitMask = HERO ;
    self.physicsBody.collisionBitMask = GROUND | WALL | TRAP ;
    self.physicsBody.contactTestBitMask = GROUND | WALL | TRAP ;
    self.health = 100 ;
    return self ;
}

-(void)jump
{
    if ((self.contact & (DOWN | LEFT | RIGHT)) != 0)
    {
        self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx, 0) ;
        [self.physicsBody applyImpulse:CGVectorMake(0, 150)] ;
    }
}

-(void)charge
{
    self.chargeStart = [NSDate date] ;
}

-(void)attackPoint:(CGPoint)point
{
    float charge = fmin(3, 1 + 2 * fabsf([self.chargeStart timeIntervalSinceNow])) ;
    [super throwProjectile:[[Arrow alloc] init] withForce:(500 * charge) toward:point] ;
}

-(void)attackCharacter:(Character *)character
{
    [self attackPoint:character.position] ;
}


@end

@implementation Enemy
-(instancetype)init
{
    self = [super initWithColor:[NSColor redColor] size:CGSizeMake(50, 50)] ;
    self.physicsBody.dynamic = NO ;
    self.physicsBody.categoryBitMask = ENEMY ;
    self.physicsBody.collisionBitMask = 0 ;
    self.physicsBody.contactTestBitMask = 0 ;
    self.health = 100 ;
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

-(void)attackPoint:(CGPoint)point
{
    [super throwProjectile:[[FireBall alloc] init] withForce:750 toward:point] ;
}

-(void)attackCharacter:(Character *)character
{
    [self attackPoint:character.position];
}

-(void)keepAttackingCharacter:(Character *)character
{
    [self runAction:
     [SKAction sequence:
      @[[SKAction repeatAction:
         [SKAction sequence:
          @[[SKAction waitForDuration:self.health / 100],
            [SKAction runBlock:^{[self attackCharacter:character];}]
            ]
          ]
                         count:5
         ],
        [SKAction waitForDuration:1]
        ]
      ]
         completion:^{[self keepAttackingCharacter:character] ;}
     ];
}

@end

