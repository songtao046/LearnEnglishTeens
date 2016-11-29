//
//  Logger.m
//  ipadnova
//
//  Created by matthew jiang on 9/4/11.
//  Copyright 2011 DawnTao. All rights reserved.
//

#import "Logger.h"
//#import "NovaModelManager.h"
//#import "NovaLog.h"
static Logger* _logger;

@implementation Logger
@synthesize level;

- (id) init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        level = LEVEL_DEBUG;
#else
        level = LEVEL_ERROR;
#endif
        
    }
    return self;
}

- (void) LogWithLevel:(LoggerLevel)aLevel format:(NSString *)format arguments:(va_list)args{
    
    if (aLevel >= level) {
        NSLogv(format,args);
    }
    
    // write error log into files
#ifdef DEBUG
    if (aLevel >= LEVEL_ERROR) {
#else
    if (aLevel >= level) {
#endif
       /* NovaModelManager* manager = [[NovaModelManager alloc] init];
        NovaLog* log = [manager insertLog];
        log.logType = [NSNumber numberWithInt:aLevel];
        
        NSString* error = [[NSString alloc] initWithFormat:format arguments:args];
        log.error = error;
        [error release];
        
        log.dateTime = [NSDate date];
        [manager save];
        [manager release];*/

    }
}

- (void) Debug:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [self LogWithLevel:LEVEL_DEBUG format:format arguments:args];
    va_end(args);
}

- (void) Warning:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [self LogWithLevel:LEVEL_WARNING format:format arguments:args];
    va_end(args);
}

- (void) Info:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [self LogWithLevel:LEVEL_INFO format:format arguments:args];
    va_end(args);
}

- (void) Error:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [self LogWithLevel:LEVEL_ERROR format:format arguments:args];
    va_end(args);
}

+(Logger*) Instance {
    if (_logger == nil) {
        _logger = [[Logger alloc] init];

    }

    return _logger;
}

- (NSString*) levelName {
    return [Logger stringFromLevel:self.level];
}

+(NSString*)stringFromLevel:(LoggerLevel)aLevel {
    NSString* str = nil;
    switch (aLevel) {
        case LEVEL_DEBUG:
            str = @"Debug";
            break;
        case LEVEL_WARNING:
            str = @"Warning";
            break;
        case LEVEL_INFO:
            str = @"Info";
            break;
        case LEVEL_ERROR:
            str = @"Error";
            break;
        default:
            break;
    }
    return str;
}
@end
