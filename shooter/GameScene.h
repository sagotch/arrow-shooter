//
//  GameScene.h
//  shooter
//

//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

enum category {
    ENEMY    = 0x1 << 1,
    HERO     = 0x1 << 2,
    GROUND   = 0x1 << 3,
    ARROW    = 0x1 << 4,
    FIREBALL = 0x1 << 5,
    WALL     = 0x1 << 6,
    TRAP     = 0x1 << 7
};

enum direction {
    LEFT  = 0x1 << 1,
    RIGHT = 0x1 << 2,
    UP    = 0x1 << 3,
    DOWN  = 0x1 << 4
};



// CHARACTERS

@class Projectile ; // Forward declaration for throwProjectile method.

@interface Character : SKSpriteNode
@property float health ;
-(void)attackPoint:(CGPoint)point;
-(void)attackCharacter:(Character *)character ;
-(void)throwProjectile:(Projectile *)projectile withForce:(float)force toward:(CGPoint)point ;
@end

@interface Hero : Character
@property int dir ;
@property int contact ;
@property NSDate* chargeStart ;
-(void) jump ;
-(void) charge ;
@end

@interface Enemy : Character
-(void)keepAttackingCharacter:(Character *)character ;
@end

// PROJECTILES

@interface Projectile : SKSpriteNode
@property float damage ;
-(void) fire :(CGPoint)from :(CGVector)toward;
-(void)hitCharacter:(Character *)c ;
@end

@interface Arrow : Projectile
@end

@interface FireBall : Projectile
@end

// GROUND

@interface Landscape : SKSpriteNode
@end

@interface Ground : Landscape
@end

@interface Wall : Landscape
@end

@interface Trap : Landscape
-(void) activate ;
-(void) deactivate ;
@end

// GAMESCENE

@interface GameScene : SKScene <SKPhysicsContactDelegate>
@property Hero * hero ;
@property Enemy * enemy ;
@property NSDate * start ;
@end
