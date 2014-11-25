//
//  Level.h
//  shooter
//
//  Created by Julien Sagot on 21/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Collidable.h"

@interface Bounds : SKNode <Collidable>
@end

@interface Level : SKNode <NSXMLParserDelegate>
@property float width ;
@property float height ;
@property CGPoint startPosition ;
-(instancetype)initWithXMLPath :(NSString *) path ;
@end
