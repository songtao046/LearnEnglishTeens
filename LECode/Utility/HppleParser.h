//
//  HppleParser.h
//  LearnEnglish
//
//  Created by Ma SongTao on 6/23/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "CategoryData.h"

typedef void(^ParserHandler)(NSArray *resultArray, BOOL success, NSString *errorMessage);

@interface HppleParser : NSObject

@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, assign) ParserHandler handler;
@property (nonatomic, assign) CategoryType type;
@property (nonatomic, assign) InfoType infoType;

-(instancetype)initWithString:(NSString *)string type:(CategoryType)type infoType:(InfoType)infoType completionHandler:(ParserHandler) handler;

-(void)parse;

@end
