//
//  Utility.h
//  LearnEnglish
//
//  Created by Ma SongTao on 6/19/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(void) initUtility;

// cache operation
+(NSString*) cacheFolder;
+(NSString*) cacheFolderForDB;
+(NSString*) cacheFolderForResource;
+(NSString*) cacheItemPath:(NSString*)fileName;

// String operation
+(BOOL) isStringEmpty:(NSString*)srcString;
+(NSString *) trimmingSpaceInSetOfString:(NSString *)src;


// file operation
+(BOOL) isFileExistsAtCache:(NSString*)fileName;
+(BOOL) isFileExists:(NSString*)fileFullPathName;
+ (BOOL)addSkipBackupAttributeToPath:(NSString*)path;
+ (BOOL)getSkipBackupAttributeToPath:(NSString*)path;

@end
