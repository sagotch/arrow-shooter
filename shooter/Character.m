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

-(void) setVelocity:(float)dx :(float)dy
{
    self.physicsBody.velocity = CGVectorMake(dx, dy) ;
}

-(void) setVelocityDY:(float) dy
{
    [self setVelocity :self.physicsBody.velocity.dx :dy] ;
}

-(void) setVelocityDX:(float) dx
{
    [self setVelocity :dx :self.physicsBody.velocity.dy] ;
}

@end

// Hero

@interface Human ()
@property int keyPressed ; // FIXME: Separate the movements and factorize with Character
@end


@implementation Human
-(instancetype)initWithColor:(NSColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size] ;
    self.physicsBody.dynamic = YES ;
    self.physicsBody.allowsRotation = NO ;
    self.physicsBody.restitution = 0 ;
    self.physicsBody.friction = 0 ;
    self.physicsBody.collisionBitMask = GROUND | WALL | TRAP ;
    self.physicsBody.contactTestBitMask = GROUND | WALL | TRAP ;
    self.contact = 0 ;
    self.keyPressed = 0 ;
    return self ;
}

-(void)keyDown:(int)keyCode
{
    switch (keyCode)
    {
        case 0:  // A
            if (!(self.keyPressed & LEFT))
            {
                [self setVelocityDX: -self.maxSpeed] ;
                self.keyPressed |= LEFT ;
            }
            break ;
        case 2:  // D
            if (!(self.keyPressed & RIGHT))
            {
                [self setVelocityDX :self.maxSpeed] ;
                self.keyPressed |= RIGHT ;
            }
            break ;
        case 13: // W
            if (!(self.keyPressed & UP))
            {
                if (self.contact & (DOWN | LEFT | RIGHT))
                {
                    self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx, 0) ;
                    [self.physicsBody applyImpulse:CGVectorMake(0, 150)] ;
                }
                self.keyPressed |= UP ;
                break ;
            }
    }
}

-(void)keyUp:(int) keyCode
{
    switch (keyCode)
    {
        case 0:  // A
            self.keyPressed &= ~LEFT ;
            [self setVelocityDX: (self.keyPressed & RIGHT ? self.maxSpeed : 0)] ;
            break ;
        case 2: // D
            self.keyPressed &= ~RIGHT ;
            [self setVelocityDX: (self.keyPressed & LEFT ? -self.maxSpeed : 0)] ;
            break ;
        case 13: // W
            self.keyPressed &= ~UP ;
    }
}

@end

@implementation Hero

-(instancetype)init
{
    self = [super initWithColor:[NSColor blueColor] size:CGSizeMake(50, 75)] ;
    self.physicsBody.categoryBitMask = HERO ;
    self.maxHealth = 100 ;
    self.health = self.maxHealth ;
    self.maxSpeed = 500 ;
    return self ;
}

-(void)mouseDown:(int)btnCode :(CGPoint)at
{
    [self charge] ;
}

-(void)mouseUp:(int)btnCode :(CGPoint)at
{
    [self attackPoint:at] ;
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

@implementation Ghost
-(instancetype) initWithColor:(NSColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size] ;
    self.physicsBody.dynamic = NO ;
    self.physicsBody.collisionBitMask = 0 ;
    self.physicsBody.contactTestBitMask = 0 ;
    return self ;
}

@end

@implementation Enemy
-(instancetype)init
{
    self = [super initWithColor:[NSColor redColor] size:CGSizeMake(50, 50)] ;
    self.physicsBody.categoryBitMask = ENEMY ;
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
                         count:(10 - self.health / 20)
         ],
        [SKAction waitForDuration:1]
        ]
      ]
         completion:^{[self keepAttackingCharacter:character] ;}
     ];
}

@end

