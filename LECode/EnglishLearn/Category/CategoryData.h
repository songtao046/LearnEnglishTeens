//
//  CategoryData.h
//  LearnEnglish
//
//  Created by Ma SongTao on 6/16/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, InfoType) {
    SkillRead = 0,
    SkillWrite = 1,
    SkillListen = 2,
    
    GrammarVideos = 0,
    GrammarPhrasal = 1,
    GrammarVocabulary = 2,
    
    ExamRead = 0,
    ExamWrite = 1,
    ExamListen = 2,
    ExamSpeak = 3,
    ExamGrammar = 4,
    ExamStudyTips = 5,
    
    UKRead = 0,
    UKVideo = 1,
    UKSP = 2,
    UKFilm = 3,
    UKMusic = 4,
    UKScience = 5,
    
    BreakVideoZone = 0,
    BreakGame = 1,
    BreakPhotoCaptions = 2,
    BreakWhatIt = 3,
    BreakEasyReading = 4,
    
    MagazineBooks = 0,
    MagazineEntertainment = 1,
    MagazineFashion = 2,
    MagazineLife = 3,
    MagazineMusic = 4,
    MagazineScience = 5,
    MagazineSport = 6,
};

//typedef NS_ENUM(NSInteger, SkillInfoType) {
//    SkillRead,
//    SkillWrite,
//    SkillListen,
//};
//
//typedef NS_ENUM(NSInteger, GrammarInfoType) {
//    GrammarVideos,
//    GrammarPhrasal,
//    GrammarVocabulary,
//};
//
//typedef NS_ENUM(NSInteger, ExamInfoType) {
//    ExamRead,
//    ExamWrite,
//    ExamListen,
//    ExamSpeak,
//    ExamGrammar,
//    ExamStudyTips
//};
//
//typedef NS_ENUM(NSInteger, UKNowInfoType) {
//    UKRead,
//    UKVideo,
//    UKSP,
//    UKFilm,
//    UKMusic,
//    UKScience,
//};
//
//typedef NS_ENUM(NSInteger, StudyBreakInfoType) {
//    BreakVideoZone,
//    BreakGame,
//    BreakPhotoCaptions,
//    BreakWhatIt,
//    BreakEasyReading,
//};
//
//typedef NS_ENUM(NSInteger, MagazineInfoType) {
//    MagazineBooks,
//    MagazineEntertainment,
//    MagazineFashion,
//    MagazineLife,
//    MagazineMusic,
//    MagazineScience,
//    MagazineSport,
//};

@interface CategoryData : NSObject

+(NSArray *)titlesWithType:(NSInteger)type;
+(NSArray *)imagesWithType:(NSInteger)type;

+(NSString *)serviceNameWithType:(CategoryType)type;
+(NSString *)pathNameWithType:(CategoryType)type index:(NSInteger)index;

@end
