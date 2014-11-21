//
//  GameScene.m
//  shooter
//
//  Created by Julien Sagot on 13/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import "GameScene.h"
#import "CGVectorAdditions.h"
#import "Character.h"
#import "Projectile.h"
#import "Landscape.h"
#import "PowerUp.h"
#import "MenuAlert.h"
#import "ScoreHistory.h"

@implementation CharacterLifeMeter

-(instancetype)initWithCharacter:(Character *)character
{
    self = [super initWithColor:[NSColor darkGrayColor] size:CGSizeMake(character.health, 5)] ;
    self.character = character ;
    self.position = CGPointMake(0, character.size.height / 2 + 10);
    [character addChild:self] ;
    return self ;
}

-(void) update
{
    self.size = CGSizeMake(self.character.health, 5) ;
}

@end

@implementation GameScene

-(instancetype)init
{
    self = [super initWithSize:CGSizeMake(1024, 768)] ;
    [SKAction playSoundFileNamed:@"arrow-fire.wav" waitForCompletion:NO];
    [SKAction playSoundFileNamed:@"arrow-hit.wav" waitForCompletion:NO];
    [SKAction playSoundFileNamed:@"fireball-fire.wav" waitForCompletion:NO];
    return self ;
}

- (void)didFinishUpdate
{
    self.world.position //= //self.hero.position ;
    = CGPointMake(-(self.hero.position.x - (self.size.width/2)),
                  -(self.hero.position.y - (self.size.height/2)));
}

- (void) didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody * a, * b;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    { a = contact.bodyA; b = contact.bodyB; }
    else
    { a = contact.bodyB; b = contact.bodyA; }
    
    if ((a.categoryBitMask & OUT_OF_BOUNDS) != 0)
    {
        [b.node removeFromParent] ;
    }
    else if ((a.categoryBitMask & HERO) != 0)
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
        else if ((b.categoryBitMask & FIREBALL) != 0)
        {
            [((FireBall *) b.node) hitCharacter:(Character *)a.node] ;
            [b.node removeFromParent] ;
        }
        else if ((b.categoryBitMask & TRAP) != 0)
        {
            [((Trap *) b.node) hitCharacter:(Character *)a.node] ;
        }
        else if ((b.categoryBitMask & POWERUP) != 0)
        {
            [((PowerUp *) b.node) powerUpCharacter:(Character *)a.node] ;
            [b.node removeFromParent] ;
        }
    }
    else if ((a.categoryBitMask & ENEMY) != 0)
    {
        if ((b.categoryBitMask & ARROW) != 0)
        {
            [((Arrow *) b.node) hitCharacter:(Character *)a.node] ;
            [b.node removeFromParent] ;
        }
    }
    else if ((((a.categoryBitMask & WALL) != 0)
              || (a.categoryBitMask & GROUND) != 0)
             && (b.categoryBitMask & ARROW) != 0)
    {
        [b.node removeFromParent] ;
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


-(void)spawnPowerUp
{
    HealthPack * p = [[HealthPack alloc] init] ;
    p.position = CGPointMake(self.size.width / 2 + arc4random_uniform(self.size.width / 2),
                             self.size.height);
    [self.world addChild:p] ;
    [p runAction:[SKAction repeatActionForever:[SKAction moveByX:0 y:-50 duration:1]]] ;
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    self.world = [[SKNode alloc] init] ;
    [self addChild:self.world] ;
    
    self.backgroundColor = [NSColor lightGrayColor] ;
    /* Setup your scene here */
    self.physicsWorld.contactDelegate = self;
    
    /* Hero setup. */
    self.hero = [[Hero alloc] init] ;
    self.hero.position = CGPointMake(300, 300);
    [self.world addChild:self.hero];
    
    /* Enemy setup */
    self.enemy = [[Enemy alloc] init] ;
    self.enemy.position = CGPointMake(800, 300);
    [self.world addChild:self.enemy];
    [self.enemy keepMovingInBounds :self.size.width / 2 + self.enemy.size.width / 2
                                   :self.enemy.size.height / 2
                                   :self.size.width - self.enemy.size.width / 2
                                   :self.size.height - self.enemy.size.height / 2] ;
    [self.enemy keepAttackingCharacter:self.hero] ;
    
    /* Add bounds */
    [self setupBounds] ;
    [self setupLevel] ;
    [self setupHud] ;
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:20],
                                                                       [SKAction runBlock:^{[self spawnPowerUp];}]]]]];
    
    self.startTime = [NSDate date] ;
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
    [self.world addChild:floor];
    [self.world addChild:lwall];
    [self.world addChild:rwall];
    [self.world addChild:roof];
    
    // TODO: Find better than setting a 10 px margin manually
    SKNode * bounds = [[SKNode alloc] init] ;
    bounds.physicsBody =
    [SKPhysicsBody bodyWithEdgeLoopFromRect:
                          CGRectMake(0, 0, self.frame.size.width + 20, self.frame.size.height + 20) ] ;
    bounds.position = CGPointMake(-10, -10) ;
    bounds.physicsBody.categoryBitMask = OUT_OF_BOUNDS ;
    bounds.physicsBody.contactTestBitMask = ~0;
    bounds.physicsBody.collisionBitMask = ~0;
    [self.world addChild:bounds] ;
    
}

-(void)setupLevel
{
    Ground * platform = [[Ground alloc] initWithWidth:100] ;
    platform.position = CGPointMake(200, 200) ;
    [self.world addChild:platform] ;
    
    Wall * wall = [[Wall alloc] initWithHeight:350] ;
    wall.position = CGPointMake(600, 175) ;
    [self.world addChild:wall] ;
    
    Wall * wall2 = [[Wall alloc] initWithHeight:200] ;
    wall2.position = CGPointMake(300, self.size.height - 100) ;
    [self.world addChild:wall2] ;
    
    Trap * trap = [[Trap alloc] initWithSize:CGSizeMake(100, 100)] ;
    trap.position = CGPointMake(0, self.size.height);
    [trap activate] ;
    [self.world addChild:trap] ;
}

-(void)updateHud
{
    [self.heroHealth update] ;
    [self.enemyHealth update] ;
}


-(void)setupHud
{
    self.heroHealth = [[CharacterLifeMeter alloc] initWithCharacter:self.hero] ;
    self.enemyHealth = [[CharacterLifeMeter alloc] initWithCharacter:self.enemy] ;
}

-(void)mouseDown:(NSEvent *)theEvent {
    [self.hero charge] ;
}

-(void)mouseUp:(NSEvent *)theEvent {
    [self.hero attackPoint:[theEvent locationInNode:self.world]] ;
}

-(void)keyDown:(NSEvent *)theEvent
{
    switch ([theEvent keyCode])
    {
        case 0:  // A
            self.hero.dir |= LEFT ;
            break ;
        case 2:  // D
            self.hero.dir |= RIGHT ;
            break ;
        case 13: // W
            [self.hero jump] ;
            break ;
        case 53: // ESC
            [self pause] ;
            break;
    }
}

-(void)keyUp:(NSEvent *)theEvent
{
    switch ([theEvent keyCode])
    {
        case 0:  // A
            self.hero.dir &= ~LEFT ;
            break ;
        case 2: // D
            self.hero.dir &= ~RIGHT ;
            break ;
    }
}

-(void)quit
{
    [self removeAllChildren] ;
    [self.view presentScene:[[MenuScene alloc] init]] ;
}

-(void)pause
{
    self.paused = YES ;
    switch ([[[PausedMenuAlert alloc] init] runModal])
    {
        case 1000:
            [self.view presentScene:[[GameScene alloc] initWithSize:self.size]] ;
            break;
        case 1001:
            [self quit] ;
            break;
        default:
            self.paused = NO ;
            break ;
    };
}

-(void) gameOver
{
    NSDate * date = [NSDate date] ;
    float time = [date timeIntervalSinceDate:self.startTime] ;
    [[[ScoreHistory alloc ] init] saveScore:[NSDate date] :time :self.hero.health ] ;
    [self quit] ;
}

-(void)update:(CFTimeInterval)currentTime
{
    if (self.hero.health <= 0 || self.enemy.health <= 0)
    {
        [self gameOver] ;
    }
    
    [self.hero updateVelocity] ;
    [self updateHud] ;
    /* Called before each frame is rendered */
}

@end

@implementation MenuScene

-(void)didMoveToView:(SKView *)view
{
    switch ([[[MainMenuAlert alloc] init] runModal])
    {
        case 1000:
            [self.view presentScene:[[GameScene alloc] init]] ;
            break;
        case 1001:
            exit (EXIT_SUCCESS);
            break;
        default:
            break ;
    };
}

@end

