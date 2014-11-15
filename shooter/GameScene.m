//
//  GameScene.m
//  shooter
//
//  Created by Julien Sagot on 13/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import "GameScene.h"
#include "CGVectorAdditions.h"

@implementation Character

-(instancetype)initWithColor:(NSColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size] ;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size] ;
    return self ;
}
@end

// Hero

@implementation Hero

-(instancetype)init
{
    self = [super initWithColor:[NSColor blueColor] size:CGSizeMake(50, 75)] ;
    self.physicsBody.dynamic = YES ;
    self.physicsBody.allowsRotation = NO ;
    self.physicsBody.categoryBitMask = HERO ;
    self.physicsBody.collisionBitMask = GROUND | WALL ;
    self.physicsBody.contactTestBitMask = GROUND | WALL ;
    return self ;
}

-(void)jump
{
    if (self.groundContact > 0)
        [self.physicsBody applyImpulse:CGVectorMake(0, 150)] ;
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
    return self ;
}
@end

// Projectile

@implementation Projectile

-(instancetype)initWithColor:(NSColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size] ;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size] ;
    return self ;
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
    self.physicsBody.collisionBitMask = GROUND | ARROW | ENEMY | WALL;
    self.physicsBody.contactTestBitMask = GROUND | ARROW | ENEMY | WALL;
    return self ;
}
@end

// FireBall
@implementation FireBall
-(instancetype)init
{
    self = [super initWithColor:[NSColor redColor] size:CGSizeMake(10, 10)] ;
    self.physicsBody.dynamic = NO ;
    self.physicsBody.categoryBitMask = FIREBALL ;
    self.physicsBody.collisionBitMask = HERO ;
    self.physicsBody.contactTestBitMask = HERO ;
    return self ;
}
@end


// Landscape
@implementation Landscape

-(instancetype)initWithSize:(CGSize)size
{
    self = [super initWithColor:[NSColor blackColor] size:size];
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size] ;
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

// GameScene

@implementation GameScene


- (void) didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody * a, * b;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    { a = contact.bodyA; b = contact.bodyB; }
    else
    { a = contact.bodyB; b = contact.bodyA; }
    
    if ((a.categoryBitMask & HERO) != 0 && (b.categoryBitMask & GROUND) != 0)
    {
        ((Hero *) a.node).groundContact += 1;
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
        ((Hero *) a.node).groundContact -= 1;
    }
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    /* Setup your scene here */
    self.physicsWorld.contactDelegate = self;
    
    /* Hero setup. */
    self.hero = [[Hero alloc] init] ;
    self.hero.position = CGPointMake(300, 300);
    [self addChild:self.hero];

    /* Enemy setup */
    self.enemy = [[Enemy alloc] init] ;
    self.enemy.position = CGPointMake(800, 300);
    [self addChild:self.enemy];
    
    /* Add bounds */
    SKSpriteNode * bounds = [[SKSpriteNode alloc] init] ;
    bounds.position = CGPointMake(0, 0) ;
    bounds.physicsBody =
    [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.size.width, self.size.height)] ;
    bounds.physicsBody.friction = 0;
    bounds.physicsBody.categoryBitMask = GROUND ;
    bounds.physicsBody.contactTestBitMask = GROUND ;
    [self addChild:bounds] ;
    
    [self setupLevel] ;
    
}

-(void)setupLevel
{
    Ground * platform = [[Ground alloc] initWithWidth:100] ;
    platform.position = CGPointMake(200, 200) ;
    [self addChild:platform] ;
    
    Wall * wall = [[Wall alloc] initWithHeight:300] ;
    wall.position = CGPointMake(600, 200) ;
    [self addChild:wall] ;
}

-(void)mouseDown:(NSEvent *)theEvent {
    self.start = [NSDate date] ;
    }

-(void)mouseUp:(NSEvent *)theEvent {
    NSLog(@"FIRE") ;
    float charge = fmin(3, 1 + 2 * fabsf([self.start timeIntervalSinceNow])) ;
    CGPoint location = [theEvent locationInNode:self];
    CGVector v = CGVectorMake((location.x - self.hero.position.x),
                              (location.y - self.hero.position.y)) ;
    v = CGVectorMultiplyByScalar(CGVectorNormalize(v), 500 * charge) ;
    
    Arrow * a = [[Arrow alloc] init];
    [a fire:self.hero.position :v];
    [self addChild:a] ;
}


-(void)keyDown:(NSEvent *)theEvent
{
    switch ([[theEvent charactersIgnoringModifiers] characterAtIndex:0])
    {
        case 'a':
        {self.hero.left = YES ; break ;}
        case 'd':
        {self.hero.right = YES ; break ;}
        case 'w':
        {[self.hero jump] ; break ;}
    }
}

-(void)keyUp:(NSEvent *)theEvent
{
    switch ([[theEvent charactersIgnoringModifiers] characterAtIndex:0])
    {
        case 'a':
        {self.hero.left = NO ; break ;}
        case 'd':
        {self.hero.right = NO ; break ;}
    }
}

-(void)update:(CFTimeInterval)currentTime {
    float speed = 400 ;
    float dx = 0;
    float dy = self.hero.physicsBody.velocity.dy ;
    if (self.hero.left) dx = -speed ;
    else if (self.hero.right) dx = speed ;
    self.hero.physicsBody.velocity = CGVectorMake(dx, dy);
    /* Called before each frame is rendered */
}

@end
