//
//  CategoryData.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/16/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//


#define LOCALIZE(a, b) NSLocalizedString(a, b)
#import "CategoryData.h"
#import "LENetManager.h"

@implementation CategoryData

+(NSArray *)categoryArrayWithType:(NSInteger)type
{
    switch (type)
    {
        case CategoryTypeSkill:
            return @[@"reading-skills-practice", @"writing-skills-practice", @"listening-skills-practice"];
        case CategoryTypeGrammar:
            return @[@"grammar-videos", @"phrasal-verb-videos", @"vocabulary-exercises"];
//        case CategoryTypeExams:
//            return @[@"reading-exams", @"writing-exams", @"listening-exams", @"speaking-exams", @"Grammar & vocabulary-exams", @"Exam-studyTips"];
        case CategoryTypeUKNow:
            return @[@"read UK", @"video UK", @"stories-and-poems UK", @"film Uk", @"music UK", @"Science UK"];
        case CategoryTypeStudyBreak:
            return @[@"video-zone", @"games", @"photo-captions", @"what-is-it?", @"easy-reading"];
        case CategoryTypeMagazine:
            return @[@"Books", @"Entertainment", @"Fashion", @"Life-around-the-world", @"Music", @"Science-and-technology", @"Sport"];
        case CategoryTypeAll:
            return nil;
        default:
            return nil;
    }
}

+(NSArray *)serviceNameArrayWithType:(NSInteger)type
{
    switch (type)
    {
        case CategoryTypeSkill:
            return @[SK_READING, SK_WRITING, SK_LISTENING];
            break;
        case CategoryTypeGrammar:
            return @[GV_VIDEOS, GV_PV_VIDEOS, GV_EXERCISES];
            break;
//        case CategoryTypeExams:
//            return @[EX_READING, EX_WRITING, EX_LISTENING, EX_SPEAKING, EX_GV, EX_STUDY_TIPS];
//            break;
        case CategoryTypeUKNow:
            return @[UK_READ, UK_VIDEO, UK_SP, UK_FILM, UK_MUSIC, UK_SCIENCE];
            break;
        case CategoryTypeStudyBreak:
            return @[SB_VIDEO_ZONE, SB_GAMES, SB_PHOTO_CAPTIONS, SB_WHAT, SB_EASY_READING];
            break;
        case CategoryTypeMagazine:
            return @[MZ_BOOKS, MZ_ENTERTAINMENT, MZ_FASHION, MZ_LIFE, MZ_MUSIC, MZ_SCIENCE, MZ_SPORT];
            break;
        case CategoryTypeAll:
            return @[LE_ALL];
            break;
        default:
            return [NSArray array];
            break;
    }
}


+(NSArray *)titlesWithType:(NSInteger)type
{
    return [self categoryArrayWithType:type];
}

+(NSArray *)imagesWithType:(NSInteger)type
{
    return nil;
}

+(NSString *)serviceNameWithType:(CategoryType)type
{
    switch (type)
    {
        case 0:
            return SERVICE_SKILL;
            break;
        case 1:
            return SERVICE_GRAMMAR;
            break;
//        case 2:
//            return SERVICE_EXAMS;
//            break;
        case 2:
            return SERVICE_UK;
            break;
        case 3:
            return SERVICE_STUDY_BREAK;
        case 4:
            return SERVICE_MAGAZINE;
            break;
        case 5:
            return SERVICE_ALL;
            break;
        default:
            return nil;
            break;
    }
}

+(NSString *)pathNameWithType:(CategoryType)type index:(NSInteger)index
{
    NSArray *serviceArray = [self serviceNameArrayWithType:type];
    return [serviceArray objectAtIndex:index];
}

@end
