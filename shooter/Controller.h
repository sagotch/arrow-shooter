//
//  Controller.h
//  shooter
//
//  Created by Julien Sagot on 25/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Character.h"

enum direction {
    LEFT  = 0x1 << 1,
    RIGHT = 0x1 << 2,
    UP    = 0x1 << 3,
    DOWN  = 0x1 << 4
};

@interface Controller : NSObject
@property Character * character ;
-(instancetype) initWithCharacter:(Character *)character ;
-(void) keyDown:(int)keyCode ;
-(void) onKeyDown:(int)keyCode;
-(void) keyUp:(int)keyCode ;
-(void) onKeyUp:(int)keyCode;
@end

@interface HumanController : Controller
@property Human * character ;
@end

@interface GhostController : Controller
@property Ghost * character ;
@end