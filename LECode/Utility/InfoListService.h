//
//  InfoListService.h
//  LearnEnglish
//
//  Created by Ma SongTao on 6/24/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LENetManager.h"

@interface InfoListService : NSObject

+(void)getInfoListWithService:(NSString *)service path:(NSString *)path pageIndex:(NSInteger)pageIndex completionHandler:(void(^)(id responseObject, NSInteger errorCode, NSError *error))completionHandler;

+(void)getInfoWithService:(NSString *)service path:(NSString *)path completionHandler:(void(^)(id responseObject, NSInteger errorCode, NSError *error)) completionHandler;

@end
