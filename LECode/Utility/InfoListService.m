//
//  InfoListService.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/24/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import "InfoListService.h"
#import "InfoListParser.h"

@implementation InfoListService

+(void)getInfoListWithService:(NSString *)service path:(NSString *)path pageIndex:(NSInteger)pageIndex completionHandler:(void(^)(id responseObject, NSInteger errorCode, NSError *error))completionHandler
{
    path = [path stringByAppendingFormat:@"?page=%ld", (unsigned long)pageIndex];
    
    [[LENetManager manager] sendRequestWithService:service path:path parameters:nil method:HTTPMethodGet needToken:NO responseHaveToken:NO isJsonRequest:YES  completionHandler:^(id responseObject, NSInteger errorCode, NSError *error){
            [[LENetManager manager] completeWithResult:responseObject errorCode:errorCode error:error completionHandler:completionHandler];
    }];
}

+(void)getInfoWithService:(NSString *)service path:(NSString *)path completionHandler:(void(^)(id responseObject, NSInteger errorCode, NSError *error)) completionHandler
{
    [[LENetManager manager] sendRequestWithService:service path:path parameters:nil method:HTTPMethodGet needToken:NO responseHaveToken:NO isJsonRequest:YES completionHandler:^(id responseObject, NSInteger errorCode, NSError *error) {
        [[LENetManager manager] completeWithResult:responseObject errorCode:errorCode error:error completionHandler:completionHandler];
    }];
}

@end
