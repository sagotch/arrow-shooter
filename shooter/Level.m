//
//  Level.m
//  shooter
//
//  Created by Julien Sagot on 21/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import "Level.h"
#import "Landscape.h"
#import "Character.h"

@implementation Bounds
-(instancetype) initWithWidth :(float)w Height:(float)h
{
    self = [super init] ;
    self.physicsBody =
    [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, w, h) ] ;
    self.position = CGPointMake(-10, -10) ;
    self.physicsBody.categoryBitMask = OUT_OF_BOUNDS ;
    self.physicsBody.contactTestBitMask = ~0;
    self.physicsBody.collisionBitMask = ~0;
    return self ;
}

-(void) didBeginContactWithBody:(SKNode<Collidable> *)b
{
    [b removeFromParent] ;
}
@end

@implementation Level

-(instancetype)initWithXMLPath:(NSString *)path
{
    self = [super init] ;
    NSXMLParser * parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]] ;
    [parser setDelegate:self] ;
    return [parser parse] ? self : nil ;
}

-(void) setupBoundsWithWidth:(float)width Height:(float)height
{
    self.width = width ;
    self.height = height ;
    
    Ground * floor = [[Ground alloc] initWithWidth:width] ;
    Wall * lwall = [[Wall alloc] initWithHeight:height] ;
    Wall * rwall = [[Wall alloc] initWithHeight:height] ;
    //TODO: Do not use Ground for roof...
    Ground * roof = [[Ground alloc] initWithWidth:width] ;
    floor.position = CGPointMake(width / 2, 0) ;
    lwall.position = CGPointMake(0, height / 2) ;
    rwall.position = CGPointMake(width, height / 2) ;
    roof.position = CGPointMake(width / 2, height) ;
    [self addChild:floor];
    [self addChild:lwall];
    [self addChild:rwall];
    [self addChild:roof];
    
    // TODO: Find better than setting a 10 px margin manually
    Bounds * bounds = [[Bounds alloc] initWithWidth:width + 20 Height:height + 20 ];
    bounds.position = CGPointMake(-10, -10) ;
    [self addChild:bounds] ;
    
}

-(Enemy *) mkEnemyInBounds :(float)xmin :(float)ymin :(float)xmax :(float)ymax
{
    Enemy * e = [[Enemy alloc] init] ;
   // [e keepMovingInBounds :xmin :ymin :xmax :ymax] ;
    return e ;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributes
{
    
#define getKey(k) [[attributes objectForKey:(k)] floatValue]
#define X         getKey(@"x")
#define Y         getKey(@"y")
#define XMIN      getKey(@"xmin")
#define YMIN      getKey(@"ymin")
#define XMAX      getKey(@"xmax")
#define YMAX      getKey(@"ymax")
#define WIDTH     getKey(@"width")
#define HEIGHT    getKey(@"height")
#define POSITION  CGPointMake(X,Y)

    if ([elementName isEqualToString:@"wall"])
    {
        Wall * wall = [[Wall alloc] initWithHeight:HEIGHT];
        wall.position = POSITION ;
        [self addChild:wall] ;
    }
    else if ([elementName isEqualToString:@"ground"])
    {
        Ground * ground = [[Ground alloc] initWithWidth:WIDTH];
        ground.position = POSITION ;
        [self addChild:ground] ;
    }
    else if ([elementName isEqualToString:@"trap"])
    {
        Trap * trap = [[Trap alloc] initWithSize:CGSizeMake(WIDTH, HEIGHT)] ;
        trap.position = POSITION ;
        [[attributes objectForKey:@"activate"] boolValue] ? [trap activate] : [trap deactivate];
        [self addChild:trap] ;
    }
    else if ([elementName isEqualToString:@"enemy"])
    {
        Enemy * e = [self mkEnemyInBounds:XMIN :YMIN :XMAX :YMAX] ;
        e.position = POSITION ;
        [self addChild:e] ;
    }
    else if ([elementName isEqualToString:@"hero"])
    {
        self.startPosition = POSITION ;
    }
    else if ([elementName isEqualToString:@"level"])
    {
        [self setupBoundsWithWidth:WIDTH Height:HEIGHT] ;
    }
    
}

@end
