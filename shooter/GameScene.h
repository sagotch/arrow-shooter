//
//  GameScene.h
//  shooter
//

//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "BitMask.h"
#import "Character.h"
#import "Projectile.h"
#import "Landscape.h"

@interface CharacterLifeMeter : SKSpriteNode
@property Character * character ;
-(instancetype)initWithCharacter:(Character *)character ;
@end

// GAMESCENE

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property SKNode * world ;

@property Hero * hero ;
@property Enemy * enemy ;

//Hud
@property CharacterLifeMeter * heroHealth ;
@property CharacterLifeMeter * enemyHealth ;

@property NSDate * startTime ;
@end

@interface MenuScene : SKScene
@end