//
//  StudyBreakParser.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/26/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import "StudyBreakParser.h"

@implementation StudyBreakParser

-(NSArray *)filterTitles
{
    switch (self.infoType)
    {
        case BreakVideoZone:
            return @[@"Most Recent", @"Most Popular", @"A to Z List"];
            break;
        case BreakGame:
        case BreakPhotoCaptions:
        case BreakWhatIt:
            return @[@"Most Recent", @"Most Popular"];
            break;
        case BreakEasyReading:
            return @[@"Level A2", @"Level B1", @"Level B2"];
        default:
            break;
    }
    return [NSArray array];
}

-(NSArray *)searchQuerys
{
    switch (self.infoType)
    {
        case BreakVideoZone:
            return @[@"//div[@id='quicktabs-tabpage-qt_articles-most_recent']", @"//div[@id='quicktabs-tabpage-qt_articles-most_popular']", @"//div[@id='quicktabs-tabpage-qt_articles-a_to_z']"];
            break;
        case BreakGame:
        case BreakPhotoCaptions:
        case BreakWhatIt:
            return @[@"//div[@id='quicktabs-tabpage-qt_articles-most_recent']", @"//div[@id='quicktabs-tabpage-qt_articles-most_popular']"];
            break;
        case BreakEasyReading:
            return @[SKILL_FILTER(2), SKILL_FILTER(3), SKILL_FILTER(4)];
        default:
            break;
    }
    return [NSArray array];
}

@end
