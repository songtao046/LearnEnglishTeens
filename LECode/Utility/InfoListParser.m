//
//  InfoListParser.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/23/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import "InfoListParser.h"
#import "SkillInfoParser.h"
#import "GrammarInfoParser.h"
#import "ExamParser.h"
#import "UKNowParser.h"
#import "StudyBreakParser.h"
#import "MagazineParser.h"
#import "Utility.h"

@implementation ParserInfo


@end

@implementation InfoListParser
+(InfoListParser *)parserWithType:(CategoryType)type infoType:(InfoType)infotype string:(NSString *)string completionHandler:(ParserHandler) handler
{
    switch (type)
    {
        case CategoryTypeSkill:
            return [[[SkillInfoParser class] alloc] initWithString:string type:type infoType:infotype completionHandler:handler];
            break;
        case CategoryTypeGrammar:
            return [[[GrammarInfoParser class] alloc] initWithString:string type:type infoType:infotype completionHandler:handler];
            break;
//        case CategoryTypeExams:
//            return [[[ExamParser class] alloc] initWithString:string type:type infoType:infotype completionHandler:handler];
        case CategoryTypeStudyBreak:
            return [[[StudyBreakParser class] alloc] initWithString:string type:type infoType:infotype completionHandler:handler];
        case CategoryTypeUKNow:
            return [[[UKNowParser class] alloc] initWithString:string type:type infoType:infotype completionHandler:handler];
        case CategoryTypeMagazine:
            return [[[MagazineParser class] alloc] initWithString:string type:type infoType:infotype completionHandler:handler];
        default:
            break;
    }
    return nil;
}

-(TFHppleElement *)getCurrentHppleWithQuery:(NSString *)query
{
    TFHpple *listHpple = [[TFHpple alloc]initWithHTMLData:[[self.htmlString stringByReplacingOccurrencesOfString:@"<br>" withString:@""] dataUsingEncoding:NSUTF8StringEncoding]];
    return  [[listHpple searchWithXPathQuery:query] firstObject];
}


-(void)parse
{
    NSArray *searchQuerys = [self searchQuerys];
    
    NSMutableArray *results = [NSMutableArray array];
    for (int i = 0; i < searchQuerys.count; i++)
    {
        TFHppleElement *currentHpple = [self getCurrentHppleWithQuery:[searchQuerys objectAtIndex:i]];
        
        NSString *fieldTitle = [self fieldNameWithHppleElement:currentHpple];
        
        NSArray *titleArray = [currentHpple searchWithXPathQuery:LIST_TITLE_NODE];
        
        NSArray *imageArray = [currentHpple searchWithXPathQuery:LIST_IMAGE_NODE];
        
        NSArray *contentArray = [currentHpple searchWithXPathQuery:LIST_CONTENT_NODE];
        
        NSString *flagString = nil;
        if (self.filterTitles.count > i)
        {
            flagString = [[self filterTitles] objectAtIndex:i];
        }

        NSMutableArray *resultArray = [NSMutableArray new];
        for (int j = 0; j < titleArray.count; j++)
        {
            ParserInfo *parser = [[ParserInfo alloc] init];
            parser.title = [self titleOfInfoWithHppleElement:[titleArray objectAtIndex:j]];
            parser.urlString = [self urlOfInfoWithHppleElement:[titleArray objectAtIndex:j]];
            if (imageArray.count > j)
            {
                parser.image = [self imageOfInfoWithHppleElement:[imageArray objectAtIndex:j]];
            }
            if (contentArray.count > j)
            {
                parser.content = [self contentOfInfoWithHppleElement:[contentArray objectAtIndex:j]];
            }
            parser.flagString = fieldTitle;
            [resultArray addObject:parser];
        }
        [results addObject:resultArray];
    }
    
    if (self.handler)
    {
        self.handler(results, YES, nil);
    }
}


#pragma mark - image , title, content, url parse
-(NSString *)imageOfInfoWithHppleElement:(TFHppleElement *)element
{
    NSDictionary *dict = [(TFHppleElement *)[[element searchWithXPathQuery:@"//div[@class='field-content']/a/img"] objectAtIndex:0] attributes] ;
    return [dict objectForKey:@"src"];
}

-(NSString *)titleOfInfoWithHppleElement:(TFHppleElement *)element
{
    return [[[element firstChildWithClassName:LIST_TAG_NAME] firstChild] text] ;
}

-(NSString *)contentOfInfoWithHppleElement:(TFHppleElement *)element
{
    return [[element firstChildWithClassName:LIST_TAG_NAME] text];
}

-(NSString *)urlOfInfoWithHppleElement:(TFHppleElement *)element
{
    return [[[[element firstChildWithClassName:LIST_TAG_NAME] firstChild] attributes] objectForKey:@"href"];
}

-(NSString *)fieldNameWithHppleElement:(TFHppleElement *)element
{
    NSString *fieldName = [[[element searchWithXPathQuery:@"//span[@class='field-content']/a/span"] firstObject] text];
    if([Utility isStringEmpty:fieldName])
    {
        fieldName = [[[element searchWithXPathQuery:@"//span[@class='field-content field-content']/a/span"] firstObject] text];
    }
    return fieldName;
}


#pragma mark - search query
-(NSArray *)filterTitles
{
    return [NSArray array];
}

-(NSArray *)searchQuerys
{
    return [NSArray array];
}
@end
