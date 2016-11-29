//
//  Info.h
//  LearnEnglish
//
//  Created by Ma SongTao on 6/19/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InfoResource;

@interface Info : NSManagedObject

@property (nonatomic, assign) int32_t type;
@property (nonatomic, assign) int32_t category;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, assign) NSTimeInterval createDate;
@property (nonatomic, assign) NSTimeInterval updateDate;
@property (nonatomic, retain) NSString * creator;
@property (nonatomic, assign) int32_t creatorId;
@property (nonatomic, assign) int32_t skimNumber;
@property (nonatomic, assign) int32_t totalReview;
@property (nonatomic, assign) int32_t totalLike;
@end

@interface Info (CoreDataGeneratedAccessors)

- (void)addInfoResourcesObject:(InfoResource *)value;
- (void)removeInfoResourcesObject:(InfoResource *)value;
- (void)addInfoResources:(NSSet *)values;
- (void)removeInfoResources:(NSSet *)values;

@end
