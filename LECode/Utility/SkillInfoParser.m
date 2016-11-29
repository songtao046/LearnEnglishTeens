//
//  SkillInfoParser.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/26/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import "SkillInfoParser.h"

@implementation SkillInfoParser

-(NSArray *)filterTitles
{
    return @[@"Level A1", @"Level A2", @"Level B1", @"Level B2"];
}

-(NSArray *)searchQuerys
{
    return @[SKILL_FILTER(1), SKILL_FILTER(2), SKILL_FILTER(3), SKILL_FILTER(4)];
}

//-(NSString *)fieldNameWithHppleElement:(TFHppleElement *)element
//{
//    return [[[element searchWithXPathQuery:@"//span[@class='field-content field-content']/a/span"] firstObject] text];
//}
@end
