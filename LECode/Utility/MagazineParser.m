//
//  MagazineParser.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/26/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import "MagazineParser.h"

@implementation MagazineParser

-(void)parse
{
    NSArray *searchQuerys = [self searchQuerys];
    
    NSMutableArray *results = [NSMutableArray array];
    for (int i = 0; i < searchQuerys.count; i++)
    {
        TFHppleElement *currentHpple = [self getCurrentHppleWithQuery:[searchQuerys objectAtIndex:i]];
        
        NSString *fieldTitle = [self fieldNameWithHppleElement:currentHpple];
        
        NSArray *titleArray = [currentHpple searchWithXPathQuery:@"//div[@class='views-field-title']"];
        
        NSArray *imageArray = [currentHpple searchWithXPathQuery:@"//div[@class='views-field-field_image']"];
        
        NSArray *contentArray = [currentHpple searchWithXPathQuery:@"//div[@class='views-field-body']"];
        
        NSArray *fieldCreatorArray = [currentHpple searchWithXPathQuery:@"//div[@class='views-field-nothing']"];

        NSArray *commentCountArray = [currentHpple searchWithXPathQuery:@"//div[@class='views-field-comment_count']"];
        
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
            if (commentCountArray.count > j)
            {
                parser.commentCount = [self commentCountWithHppleElement:[commentCountArray objectAtIndex:j]];
            }
            
            if (fieldCreatorArray.count > j)
            {
                parser.fieldNothing = [self fieldNothingWithHppleElement:[fieldCreatorArray objectAtIndex:j]];
            }

            [resultArray addObject:parser];
        }
        [results addObject:resultArray];
    }
    
    if (self.handler)
    {
        self.handler(results, YES, nil);
    }
}

-(NSArray *)searchQuerys
{
    return @[@"//div[@id='main-content']//div[@class='view-content']"];
}

-(NSString *)imageOfInfoWithHppleElement:(TFHppleElement *)element
{
    NSDictionary *dict = [(TFHppleElement *)[[element searchWithXPathQuery:@"//div[@class='views-field-field_image']/a/img"] objectAtIndex:0] attributes] ;
    return [dict objectForKey:@"src"];
}

-(NSString *)fieldNothingWithHppleElement:(TFHppleElement *)element
{
    return [[element firstChildWithTagName:@"a"] text] ;
}

-(NSString *)titleOfInfoWithHppleElement:(TFHppleElement *)element
{
    return [[element firstChildWithTagName:@"a"] text] ;
}

-(NSString *)contentOfInfoWithHppleElement:(TFHppleElement *)element
{
    return [element text];
}

-(NSString *)urlOfInfoWithHppleElement:(TFHppleElement *)element
{
    return [[[element firstChildWithTagName:@"a"] attributes] objectForKey:@"href"];
}

-(NSString *)fieldNameWithHppleElement:(TFHppleElement *)element
{
    NSString *fieldName = [[[element searchWithXPathQuery:@"//a/span"] firstObject] text];
    return fieldName;
}

-(NSInteger)commentCountWithHppleElement:(TFHppleElement *)element
{
    return [[element text] integerValue];
}


@end
