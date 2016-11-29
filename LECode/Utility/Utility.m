//
//  Utility.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/19/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import "Utility.h"
#import "Logger.h"
#include <sys/xattr.h>

#import <sys/socket.h> // Per msqr
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

#import <sys/utsname.h>
#import <mach/mach.h>

@implementation Utility

static NSDateFormatter* dateFormatter;
static NSString* cacheResourceFullPath;
static NSString* UDID;

+(void) cleanOldCacheFile {
    // clear old cache file
    NSString* oldResourceFolder = [[self oldCacheFolder] stringByAppendingPathComponent:@"resource"];
    
    if ([self isFileExists:oldResourceFolder]) {
        NSError* error;
        if([[NSFileManager defaultManager] removeItemAtPath:oldResourceFolder error:&error] == NO) {
            [[Logger Instance] Error:@"delete old resource file failed:%@ - %@",oldResourceFolder,error];
        }
    }
    
    NSString* oldDBFolder = [self oldCacheFolderForDB];
    if ([self isFileExists:oldDBFolder]) {
        NSError* error;
        if([[NSFileManager defaultManager] removeItemAtPath:oldDBFolder error:&error] == NO) {
            [[Logger Instance] Error:@"delete old resource file failed:%@ - %@",oldDBFolder,error];
        }
    }
}


+(void) initUtility {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [self cleanOldCacheFile];
    
    if (cacheResourceFullPath == nil) {
        cacheResourceFullPath = [[NSString alloc] initWithString:[[self cacheFolder] stringByAppendingPathComponent:@"resource"]];
    }
    
    NSString* resourceFold = [self cacheFolderForResource];
    if (resourceFold!= nil && [[NSFileManager defaultManager] fileExistsAtPath:resourceFold]) {
        BOOL flag = [self addSkipBackupAttributeToPath:resourceFold];
        
        if (!flag) {
            [[Logger Instance] Error:@"Set do not backup attribute failed:%@", resourceFold];
        }
    }
    
    
    NSString* dbFolder = [self cacheFolderForDB];
    if (dbFolder != nil && [[NSFileManager defaultManager] fileExistsAtPath:dbFolder] ) {
        BOOL flag = [self addSkipBackupAttributeToPath:dbFolder];
        
        if (!flag) {
            [[Logger Instance] Error:@"Set do not backup attribute failed:%@", dbFolder];
        }
    }
}

+ (NSString*) cacheItemPath:(NSString *)fileName
{
    return [cacheResourceFullPath stringByAppendingPathComponent:fileName];
}

+(NSString*) oldCacheFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
    
    //return [[NSBundle bundleForClass:[Utility class]] bundlePath];
}

+(NSString*) cacheFolder {
    NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[libraryPaths objectAtIndex:0] stringByAppendingPathComponent:@"Private Documents"];
    
}

+ (NSString*) defaultResource {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"resource"];
}

+ (NSString*) defaultDB {
    return [[NSBundle mainBundle] pathForResource:@"nova.z" ofType:@"sqlite"];
}

+(NSString*) oldCacheFolderForDB {
    return [[self oldCacheFolder] stringByAppendingPathComponent:@"db"];
}

+(NSString*) cacheFolderForDB {
    NSError* error = nil;
    NSString* folder = [[self cacheFolder] stringByAppendingPathComponent:@"db"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:folder] == NO ) {
        if ([[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
            [[Logger Instance] Error:@"Create folder failed: %@ - %@", folder,error];
        }
    }
    /*
     NSString* dbFile = [folder stringByAppendingPathComponent:@"nova.z.sqlite"];
     
     if ([[NSFileManager defaultManager] fileExistsAtPath:dbFile] == NO && [[NSFileManager defaultManager] fileExistsAtPath:[self defaultDB]]) {
     #ifdef DEBUG
     // skip copy in debug
     #else
     // if db file does not exists, copy default db file
     if ([[NSFileManager defaultManager] copyItemAtPath:[self defaultDB] toPath:dbFile error:&error] == NO) {
     [[Logger Instance] Error:@"Copy default db failed: %@ - %@, %@", [self defaultDB], dbFile, error];
     }
     #endif
     }*/
    return  folder;
}

+(NSString*) cacheFolderForResource {
    NSString* folder =  cacheResourceFullPath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:folder] == NO ) {
        NSError* error = nil;
        if ([[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
            [[Logger Instance] Error:@"Create cahce resource folder failed:%@ - %@", folder,error];
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:folder]) {
            BOOL flag = [self addSkipBackupAttributeToPath:folder];
            
            if (!flag) {
                [[Logger Instance] Error:@"Set do not backup attribute failed:%@", folder];
            }
            
        }
        
    }
    
    return folder;
}


// String operation
+(BOOL) isStringEmpty:(NSString*)srcString
{
    if (srcString == nil
        || [srcString length] == 0
        || [[srcString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    
    return NO;
}

+(NSString *) trimmingSpaceInSetOfString:(NSString *)src
{
    return [src stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// File operation
+(BOOL) isFileExists:(NSString *)fileFullPathName {
    if ([self isStringEmpty:fileFullPathName]) {
        return NO;
    }
    
    return [[NSFileManager defaultManager] fileExistsAtPath:fileFullPathName];
}

+(BOOL) isFileExistsAtCache:(NSString *)fileName {
    if ([self isStringEmpty:fileName]) {
        return NO;
    }
    NSString* fileFullPath = [self cacheItemPath:fileName];
    
    return [self isFileExists:fileFullPath];
}

+ (BOOL)addSkipBackupAttributeToPath:(NSString*)path;
{
    const char* filePath = [path fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

+ (BOOL)getSkipBackupAttributeToPath:(NSString*)path {
    const char* filePath = [path fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 0;
    
    NSInteger result = getxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    if (result != 0) {
        [[Logger Instance] Error:@"get attr failed:%d", errno];
        return NO;
    }
    
    return attrValue == 1;
}


@end
