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
#import "Level.h"

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
    self.keyPress = 0 ;
    return self ;
}

- (void)didFinishUpdate
{
    self.world.position //= //self.player.position ;
    = CGPointMake(-(self.player.position.x - (self.size.width/2)),
                  -(self.player.position.y - (self.size.height/2)));
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

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    self.physicsWorld.contactDelegate = self;

    self.backgroundColor = [NSColor lightGrayColor] ;
    self.world = [[SKNode alloc] init] ;
    [self addChild:self.world] ;

    NSString * path = [[NSBundle mainBundle] pathForResource:@"room-empty" ofType:@"xml"] ;
    Level * level = [[Level alloc] initWithXMLPath:path] ;
    [self.world addChild:level] ;
    
    /* Hero setup. */
    self.player = [[Hero alloc] init] ;
    self.player.position = level.startPosition ;
    [self.world addChild:self.player];
    
    self.heroHealth = [[CharacterLifeMeter alloc] initWithCharacter:self.player] ;
    
    self.startTime = [NSDate date] ;
}

-(void)mouseDown:(NSEvent *)theEvent {
    [self.player mouseDown:1 :[theEvent locationInNode:self.world]];
}

-(void)mouseUp:(NSEvent *)theEvent {
    [self.player mouseUp:1 :[theEvent locationInNode:self.world]] ;
}

-(void)keyDown:(NSEvent *)theEvent
{
    int code = [theEvent keyCode] ;
    switch (code)
    {
        case 53: // ESC
            [self pause] ;
            break;
        default:
            [self.player keyDown:code] ;
    }
}

-(void)keyUp:(NSEvent *)theEvent
{
    [self.player keyUp:[theEvent keyCode]] ;
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
    [[[ScoreHistory alloc ] init] saveScore:[NSDate date] :time :self.player.health ] ;
    [self quit] ;
}

-(void)update:(CFTimeInterval)currentTime
{
    if (self.player.health <= 0)
    {
        [self gameOver] ;
    }
    [self.heroHealth update] ;
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

