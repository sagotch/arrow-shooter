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
#import "Controller.h"
#import "Collidable.h"

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
    if (contact.bodyA.contactTestBitMask & contact.bodyB.categoryBitMask)
    {
        [((SKNode <Collidable> *) contact.bodyA.node)
         didBeginContactWithBody:((SKNode <Collidable> *) contact.bodyB.node)] ;
    }
    if (contact.bodyB.contactTestBitMask & contact.bodyA.categoryBitMask)
    {
        [((SKNode <Collidable> *) contact.bodyB.node)
         didBeginContactWithBody:((SKNode <Collidable> *) contact.bodyA.node)] ;
    }
}

-(void) didEndContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.contactTestBitMask & contact.bodyB.categoryBitMask)
    {
        [((SKNode <Collidable> *) contact.bodyA.node)
         didEndContactWithBody:((SKNode <Collidable> *) contact.bodyB.node)] ;
    }
    if (contact.bodyB.contactTestBitMask & contact.bodyA.categoryBitMask)
    {
        [((SKNode <Collidable> *) contact.bodyB.node)
         didEndContactWithBody:((SKNode <Collidable> *) contact.bodyA.node)] ;
    }
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    self.physicsWorld.contactDelegate = self;

    self.backgroundColor = [NSColor lightGrayColor] ;
    self.world = [[SKNode alloc] init] ;
    [self addChild:self.world] ;

    NSString * path = [[NSBundle mainBundle] pathForResource:@"room-enemy" ofType:@"xml"] ;
    Level * level = [[Level alloc] initWithXMLPath:path] ;
    [self.world addChild:level] ;
    
    /* Hero setup. */
    self.player = [[Hero alloc] init] ;
    self.player.position = level.startPosition ;
    self.player.weapon = [[Bow alloc] init] ;
    [self.player addChild:self.player.weapon] ;
    [self.world addChild:self.player];
    
    self.heroController = [[HumanController alloc] initWithCharacter:self.player] ;
    self.weaponController = [[BowController alloc] initWithWeapon:self.player.weapon] ;
    self.heroHealth = [[CharacterLifeMeter alloc] initWithCharacter:self.player] ;
    
    self.startTime = [NSDate date] ;
}

-(void)mouseDown:(NSEvent *)theEvent {
    [self.weaponController mouseDown:1 :[theEvent locationInNode:self.player.weapon]];
}

-(void)mouseUp:(NSEvent *)theEvent {
    [self.weaponController mouseUp:1 :[theEvent locationInNode:self.player.weapon]] ;
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
            [self.heroController keyDown:code] ;
    }
}

-(void)keyUp:(NSEvent *)theEvent
{
    [self.heroController keyUp:[theEvent keyCode]] ;
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

