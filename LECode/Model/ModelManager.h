//
//  ModelManager.h
//  LearnEnglish
//
//  Created by Ma SongTao on 6/19/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Info.h"


#define ENTITY_INFO @"Info"
#define ENTITY_INFO_RESOURCE @"InfoResource"

@interface ModelManager : NSObject {
    NSManagedObjectContext* _managedObjectContext;
}

@property (nonatomic, strong, readonly) NSString* persistentFileName;
@property (nonatomic, strong, readonly) NSManagedObjectContext* managedObjectContext;


+ (NSString*) getPersistentFileName;

//Info
-(Info*)insertNewInfo;

//InfoResource
@end
