//
//  GameScene.h
//  shooter
//

//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

enum {
    ENEMY    = 0x1 << 1,
    HERO     = 0x1 << 2,
    GROUND   = 0x1 << 3,
    ARROW    = 0x1 << 4,
    FIREBALL = 0x1 << 5
};


// CHARACTERS

@interface Character : SKSpriteNode
@end

@interface Hero : Character
@property bool left ;
@property bool right ;
@property int groundContact ;
-(void) jump ;
@end

@interface Enemy : Character
@end

// PROJECTILES

@interface Projectile : SKSpriteNode
-(void) fire :(CGPoint)from :(CGVector)toward;
@end

@interface Arrow : Projectile
@end

@interface FireBall : Projectile
@end

// GAMESCENE

@interface GameScene : SKScene <SKPhysicsContactDelegate>
@property Hero * hero ;
@property Enemy * enemy ;
@property NSDate * start ;
@end
