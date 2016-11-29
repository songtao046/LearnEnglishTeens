//
//  SETalkingData.h
//  StoneEngine
//
//  Created by Ma SongTao on 12/28/14.
//  Copyright (c) 2014 matthew jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkingData.h"

#define NSStringFromInteger(number) [[NSNumber numberWithInteger:number] stringValue]
#define NSStringFromNotBeNullString(string) (string == nil ? @"null" : string)

//TalkingData Event

#define HTTPRequestEvent @"Request"
#define HTTPRequestErrorEvent @"Error"
#define SEQiniuUpload     @"QNUpload"
#define SEQiniuFullImageDownLoad @"QNImageLoad"
#define SEQiniuError        @"QNError"
#define SEWeiChatShare               @"Share"
#define SEFollowInfoGroupEvent @"Follow"
#define SEUnfollowInfoGroupEvent @"unFollow"

//TalkingData Label


//Key in TalkingData parameters
#define SEDevice              @"Device"
#define SENetwork           @"Network"
#define SEErrorCode        @"ErrorCode"
#define SEDetailPath        @"URL"
#define SEDuration           @"Duration"
#define SEReourceKey     @"ResourceKey"
#define SEInfoGroupType     @"InfoGroupType"

@interface SETalkingData : NSObject


+(NSDictionary *)trackWithEvent:(NSString *)event label:(NSString *)label dicWithKeys:(NSArray *)keys andValues:(NSArray *)values;
+(NSString *)levelOfDuration:(NSTimeInterval)duration;

@end
