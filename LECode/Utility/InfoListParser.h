//
//  InfoListParser.h
//  LearnEnglish
//
//  Created by Ma SongTao on 6/23/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import "HppleParser.h"

#define LIST_IMAGE_NODE @"//div[@class='views-field views-field-field-image']"
#define LIST_TITLE_NODE @"//div[@class='views-field views-field-title']"
#define LIST_CONTENT_NODE @"//div[@class='views-field views-field-field-teaser']"
#define LIST_TAG_NAME @"field-content"

#define SKILL_FILTER(x) [NSString stringWithFormat:@"//div[@id='quicktabs-tabpage-qt_articles-level_%d']", x]

@interface ParserInfo : NSObject

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *flagString;

@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString *fieldNothing;

@end

@interface InfoListParser : HppleParser

+(InfoListParser *)parserWithType:(CategoryType)type infoType:(InfoType)infotype string:(NSString *)string completionHandler:(ParserHandler) handler;

-(TFHppleElement *)getCurrentHppleWithQuery:(NSString *)query;
-(NSArray *)searchQuerys;
-(NSArray *)filterTitles;

-(NSString *)imageOfInfoWithHppleElement:(TFHppleElement *)element;
-(NSString *)titleOfInfoWithHppleElement:(TFHppleElement *)element;
-(NSString *)contentOfInfoWithHppleElement:(TFHppleElement *)element;
-(NSString *)urlOfInfoWithHppleElement:(TFHppleElement *)element;
-(NSString *)fieldNameWithHppleElement:(TFHppleElement *)element;
@end
