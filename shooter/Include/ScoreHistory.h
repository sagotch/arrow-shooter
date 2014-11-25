//
//  ScoreHistory.h
//  shooter
//
//  Created by Julien Sagot on 18/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreHistory : NSObject
@property NSString * scoreDir ;
@property NSString * scoreFile ;
-(void)saveScore:(NSDate *)date :(float)time :(float)health ;
@end
