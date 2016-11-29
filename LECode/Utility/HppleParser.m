//
//  HppleParser.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/23/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import "HppleParser.h"

@implementation HppleParser

-(instancetype)initWithString:(NSString *)string type:(CategoryType)type infoType:(InfoType)infoType completionHandler:(ParserHandler) handler
{
    self = [super init];
    if (self != nil)
    {
        self.handler = handler;
        self.htmlString = string;
        self.type = type;
        self.infoType = infoType;
    }
    return self;
}

-(void)parse
{
    
}

@end
