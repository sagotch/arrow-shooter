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


// GAMESCENE

@interface GameScene : SKScene <SKPhysicsContactDelegate>
@property Hero * hero ;
@property Enemy * enemy ;
//Hud
@property SKLabelNode * heroHealth ;
@property SKLabelNode * enemyHealth ;
@property NSDate * start ;
@property SKNode * sound ;
@property float lastPowerUpPop ;
@end
