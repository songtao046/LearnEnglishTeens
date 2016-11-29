//
//  Logger.h
//  ipadnova
//
//  Created by matthew jiang on 9/4/11.
//  Copyright 2011 DawnTao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NovaModelManager;
typedef enum {
    LEVEL_DEBUG = 0
    , LEVEL_WARNING = 1
    , LEVEL_INFO = 2
    , LEVEL_ERROR = 3
} LoggerLevel;

@interface Logger : NSObject {
    LoggerLevel level;
}

@property (nonatomic, assign) LoggerLevel level;
@property (nonatomic, readonly) NSString* levelName;

- (void) Debug:(NSString*)format , ...;
- (void) Warning:(NSString*)format, ...;
- (void) Info:(NSString*)format, ...;
- (void) Error:(NSString*)format, ...;

-(void) LogWithLevel:(LoggerLevel)level format:(NSString *)format arguments:(va_list)args;
+(Logger*) Instance;
+(NSString*) stringFromLevel:(LoggerLevel)aLevel;
@end
