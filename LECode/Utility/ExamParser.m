//
//  ExamParser.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/26/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import "ExamParser.h"

@implementation ExamParser

-(NSArray *)filterTitles
{
    return @[@"Most Recent", @"Most Popular", @"A to Z List"];
}

-(NSArray *)searchQuerys
{
    return @[@"//div[@id='quicktabs-tabpage-qt_articles-most_recent']", @"//div[@id='quicktabs-tabpage-qt_articles-most_popular']", @"//div[@id='quicktabs-tabpage-qt_articles-a_to_z']"];
}


@end
