//
//  SETalkingData.m
//  StoneEngine
//
//  Created by Ma SongTao on 12/28/14.
//  Copyright (c) 2014 matthew jiang. All rights reserved.
//

#import "SETalkingData.h"

@implementation SETalkingData

+(NSDictionary *)trackWithEvent:(NSString *)event label:(NSString *)label dicWithKeys:(NSArray *)keys andValues:(NSArray *)values
{
    if (keys.count != values.count)
    {
        return nil;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
    [TalkingData trackEvent:event label:label parameters:dic];
    return dic;
}

+(NSString *)levelOfDuration:(NSTimeInterval)duration
{
    NSInteger level = 0;
    for (level = 0; level < 2; level ++)
    {
        if (duration > level * 0.1 && duration < level*0.1 + 0.1)
        {
            return [[NSNumber numberWithInteger:level] stringValue];
        }
    }
    
    for (level = 2; level < 6; level ++)
    {
        if (duration > level*0.1 && duration < level *0.2)
        {
            return [[NSNumber numberWithInteger:level] stringValue];
        }
    }
    
    for (level = 6; level < 8; level ++)
    {
        if (duration > level*0.5 - 2.0 && duration < level*0.5-1.5)
        {
            return [[NSNumber numberWithInteger:level] stringValue];
        }
    }
    
    for (level = 8; level < 10; level ++)
    {
        if (duration > level - 5.0 && duration < level - 6.0)
        {
            return [[NSNumber numberWithInteger:level] stringValue];
        }
    }
    
    level = 10;
    return [[NSNumber numberWithInteger:level] stringValue];
}



@end
