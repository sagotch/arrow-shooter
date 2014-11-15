//
//  GameScene.m
//  shooter
//
//  Created by Julien Sagot on 13/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import "GameScene.h"
#include "CGVectorAdditions.h"

@implementation GameScene

enum {
    ENEMY = 0x1 << 1,
    HERO   = 0x1 << 2,
    GROUND = 0x1 << 3,
    BULLET = 0x1 << 4
};


- (void) didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody * a, * b;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    { a = contact.bodyA; b = contact.bodyB; }
    else
    { a = contact.bodyB; b = contact.bodyA; }
    
    if ((a.categoryBitMask & HERO) != 0 && (b.categoryBitMask & GROUND) != 0)
    {
        self.groundContact += 1;
    }
}

-(void) didEndContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody * a, * b;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    { a = contact.bodyA; b = contact.bodyB; }
    else
    { a = contact.bodyB; b = contact.bodyA; }
    
    if ((a.categoryBitMask & HERO) != 0 && (b.categoryBitMask & GROUND) != 0)
    {
        self.groundContact -= 1;
    }
}

-(void)shoot :(CGPoint)l :(CGVector)v
{
    NSLog(@"shoot") ;
    SKSpriteNode * bullet = [SKSpriteNode spriteNodeWithColor:[NSColor redColor]
                                                         size:CGSizeMake(10, 10)] ;
    bullet.position = l ;
    bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bullet.size];
    bullet.physicsBody.dynamic = YES ;
    bullet.physicsBody.velocity = v ;
    bullet.physicsBody.affectedByGravity = YES ;
    bullet.physicsBody.categoryBitMask = BULLET ;
    bullet.physicsBody.collisionBitMask = GROUND | BULLET | ENEMY ;
    bullet.physicsBody.contactTestBitMask = GROUND | BULLET | ENEMY ;
    [self addChild:bullet] ;
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    /* Setup your scene here */
    self.physicsWorld.contactDelegate = self;
    
    /* Hero setup. */
    self.hero = [[SKSpriteNode alloc] initWithColor:[NSColor blueColor]
                                            size:CGSizeMake(50, 50)] ;
    self.hero.position = CGPointMake(300, 300);
    self.hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.hero.size] ;
    self.hero.physicsBody.affectedByGravity = YES ;
    self.hero.physicsBody.allowsRotation = NO ;
    //self.hero.physicsBody.mass = 0.0 ;
    self.hero.physicsBody.dynamic = YES ;
    self.hero.physicsBody.categoryBitMask = HERO ;
    self.hero.physicsBody.collisionBitMask = GROUND ;
    self.hero.physicsBody.contactTestBitMask = GROUND ;
    [self addChild:self.hero];

    self.groundContact = 0 ;
    
    /* Enemy setup */
    self.enemy = [[SKSpriteNode alloc] initWithColor:[NSColor redColor]
                                               size:CGSizeMake(50, 50)] ;
    self.enemy.position = CGPointMake(800, 300);
    self.enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.enemy.size] ;
    self.enemy.physicsBody.affectedByGravity = NO ;
    self.enemy.physicsBody.allowsRotation = NO ;
    self.enemy.physicsBody.dynamic = NO ;
    self.enemy.physicsBody.categoryBitMask = ENEMY ;
    self.enemy.physicsBody.collisionBitMask = 0 ;
    self.enemy.physicsBody.contactTestBitMask = 0 ;
    [self addChild:self.enemy];
    [self runAction:
     [SKAction repeatActionForever:
      [SKAction sequence:
       @[[SKAction waitForDuration:1],
         [SKAction runBlock:^{
          [self shoot :self.enemy.position :CGVectorMake(100,100)];
      }]]]]];

    
    /* Add bounds */
    SKSpriteNode * bounds = [[SKSpriteNode alloc] init] ;
    bounds.position = CGPointMake(0, 0) ;
    bounds.physicsBody =
    [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.size.width, self.size.height)] ;
    bounds.physicsBody.friction = 0;
    // BUG: touch left or right limit and jump wont be available anymore...
    bounds.physicsBody.categoryBitMask = GROUND ;
    //bounds.physicsBody.contactTestBitMask = GROUND ;
    [self addChild:bounds] ;
    
    [self setupLevel] ;
    
}

-(void)setupLevel
{
    SKSpriteNode * platform = [[SKSpriteNode alloc] initWithColor:[NSColor blackColor] size:CGSizeMake(100, 1)] ;
    platform.position = CGPointMake(400, 400) ;
    platform.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:platform.size] ;
    platform.physicsBody.friction = 0;
    platform.physicsBody.dynamic = NO ;
    platform.physicsBody.contactTestBitMask = GROUND ;
    [self addChild:platform] ;
    
}

-(void)mouseDown:(NSEvent *)theEvent {
    self.start = [NSDate date] ;
    }

-(void)mouseUp:(NSEvent *)theEvent {
    float charge = fmin(3, 1 + 2 * fabsf([self.start timeIntervalSinceNow])) ;
    CGPoint location = [theEvent locationInNode:self];
    CGVector v = CGVectorMake((location.x - self.hero.position.x),
                              (location.y - self.hero.position.y)) ;
    v = CGVectorMultiplyByScalar(CGVectorNormalize(v), 500 * charge) ;
    
    [self shoot:self.hero.position :v] ;
}


-(void)keyDown:(NSEvent *)theEvent
{
    switch ([[theEvent charactersIgnoringModifiers] characterAtIndex:0])
    {
        case 'a':
        {self.left = YES ; break ;}
        case 'd':
        {self.right = YES ; break ;}
        case 'w':
        {if (self.groundContact > 0)[self.hero.physicsBody applyImpulse:CGVectorMake(0, 75)] ; break;}
    }
}

-(void)keyUp:(NSEvent *)theEvent
{
    switch ([[theEvent charactersIgnoringModifiers] characterAtIndex:0])
    {
        case 'a':
        {self.left = NO ; break ;}
        case 'd':
        {self.right = NO ; break ;}
    }
}

-(void)update:(CFTimeInterval)currentTime {
    float speed = 400 ;
    float dx = 0;
    float dy = self.hero.physicsBody.velocity.dy ;
    if (self.left) dx = -speed ;
    else if (self.right) dx = speed ;
    self.hero.physicsBody.velocity = CGVectorMake(dx, dy);
    /* Called before each frame is rendered */
}

@end
