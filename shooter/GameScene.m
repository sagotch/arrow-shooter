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
    self.physicsBody.restitution = 0 ;
    self.physicsBody.categoryBitMask = HERO ;
    self.physicsBody.collisionBitMask = GROUND | WALL | TRAP ;
    self.physicsBody.contactTestBitMask = GROUND | WALL | TRAP ;
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

-(void)attack:(CGPoint)that
{
    float charge = fmin(3, 1 + 2 * fabsf([self.chargeStart timeIntervalSinceNow])) ;
    CGVector v = CGVectorMake(that.x - self.position.x, that.y - self.position.y) ;
    v = CGVectorMultiplyByScalar(CGVectorNormalize(v), 500 * charge) ;
    
    Arrow * a = [[Arrow alloc] init];
    [a fire:self.position :v];
    [self.parent addChild:a] ;
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

-(void)attack:(CGPoint)that
{
    CGVector v = CGVectorMake((that.x - self.position.x),
                              (that.y - self.position.y)) ;
    v = CGVectorMultiplyByScalar(CGVectorNormalize(v), 750) ;
    FireBall * f = [[FireBall alloc] init];
    [f fire:self.position :v];
    [self.parent addChild:f] ;
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
    self.physicsBody.collisionBitMask = GROUND | ARROW | ENEMY | WALL ;
    self.physicsBody.contactTestBitMask = GROUND | ARROW | ENEMY | WALL ;
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
    return self ;
}
@end


// Landscape
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
    return self ;
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

// GameScene

@implementation GameScene


- (void) didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody * a, * b;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    { a = contact.bodyA; b = contact.bodyB; }
    else
    { a = contact.bodyB; b = contact.bodyA; }
    
    if ((a.categoryBitMask & HERO) != 0)
    {
        if ((b.categoryBitMask & GROUND) != 0)
        {
            ((Hero *) a.node).contact |= DOWN ;
        }
        else if ((b.categoryBitMask & WALL) != 0)
        {
            ((Hero *) a.node).contact |=
            (a.node.position.x < b.node.position.x ? RIGHT : LEFT) ;
        }
    }
}

-(void) didEndContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody * a, * b;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    { a = contact.bodyA; b = contact.bodyB; }
    else
    { a = contact.bodyB; b = contact.bodyA; }
    
    if ((a.categoryBitMask & HERO) != 0)
    {
        if ((b.categoryBitMask & GROUND) != 0)
        {
            ((Hero *) a.node).contact &= (~DOWN);
        }
        else if ((b.categoryBitMask & WALL) != 0)
        {
            ((Hero *) a.node).contact &=
            ~(a.node.position.x < b.node.position.x ? RIGHT : LEFT) ;
        }
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
    
    [self.enemy runAction:
     [SKAction repeatActionForever:
      [SKAction sequence:
       @[[SKAction waitForDuration:1],
         [SKAction runBlock:^{[self.enemy attack:self.hero.position];}]]
       ]
      ]
     ];
    
    /* Add bounds */
    [self setupBounds] ;
    [self setupLevel] ;
    
}

-(void) setupBounds
{
    Ground * floor = [[Ground alloc] initWithWidth:self.size.width] ;
    Wall * lwall = [[Wall alloc] initWithHeight:self.size.height] ;
    Wall * rwall = [[Wall alloc] initWithHeight:self.size.height] ;
 //TODO: Do not use Ground for roof...
    Ground * roof = [[Ground alloc] initWithWidth:self.size.width] ;
    floor.position = CGPointMake(self.size.width / 2, 0) ;
    lwall.position = CGPointMake(0, self.size.height / 2) ;
    rwall.position = CGPointMake(self.size.width, self.size.height / 2) ;
    roof.position = CGPointMake(self.size.width / 2, self.size.height) ;
    [self addChild:floor];
    [self addChild:lwall];
    [self addChild:rwall];
    [self addChild:roof];
}

-(void)setupLevel
{
    Ground * platform = [[Ground alloc] initWithWidth:100] ;
    platform.position = CGPointMake(200, 200) ;
    [self addChild:platform] ;
    
    Wall * wall = [[Wall alloc] initWithHeight:350] ;
    wall.position = CGPointMake(600, 175) ;
    [self addChild:wall] ;
    
    Wall * wall2 = [[Wall alloc] initWithHeight:200] ;
    wall2.position = CGPointMake(300, self.size.height - 100) ;
    [self addChild:wall2] ;
    
    Trap * trap = [[Trap alloc] initWithSize:CGSizeMake(100, 100)] ;
    trap.position = CGPointMake(0, self.size.height);
    [trap activate] ;
    [self addChild:trap] ;
}

-(void)mouseDown:(NSEvent *)theEvent {
    [self.hero charge] ;
}

-(void)mouseUp:(NSEvent *)theEvent {
    [self.hero attack:[theEvent locationInNode:self]] ;
}


-(void)keyDown:(NSEvent *)theEvent
{
    switch ([[theEvent charactersIgnoringModifiers] characterAtIndex:0])
    {
        case 'a':
        {self.hero.dir |= LEFT ; break ;}
        case 'd':
        {self.hero.dir |= RIGHT ; break ;}
        case 'w':
        {[self.hero jump] ; break ;}
    }
}

-(void)keyUp:(NSEvent *)theEvent
{
    switch ([[theEvent charactersIgnoringModifiers] characterAtIndex:0])
    {
        case 'a':
        {self.hero.dir &= ~LEFT ; break ;}
        case 'd':
        {self.hero.dir &= ~RIGHT ; break ;}
    }
}

-(void)update:(CFTimeInterval)currentTime {
    float speed = 400 ;
    float dx = 0;
    float dy = self.hero.physicsBody.velocity.dy ;
    if ((self.hero.dir & LEFT) != 0) dx = -speed ;
    else if ((self.hero.dir & RIGHT) != 0) dx = speed ;
    self.hero.physicsBody.velocity = CGVectorMake(dx, dy);
    /* Called before each frame is rendered */
}

@end
