//
//  GameScene.h
//  shooter
//

//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>
@property SKSpriteNode * hero ;
@property bool left ;
@property bool right ;
@property int groundContact ;
@property NSDate * start ;
@end
