//
//  ModelManager.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/19/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import "ModelManager.h"
#import "Utility.h"
#import "Logger.h"

#define DEFAULT_TOKEN_EXPIRED_TIME 3600 * 24 // 1 day

static NSPersistentStoreCoordinator* g_persistentStoreCoordinator;

@interface ModelManager ()

+ (NSManagedObjectModel*) managedObjectModel;
+ (NSPersistentStoreCoordinator*) persistentStoreCoordinator;

-(NSArray*) getAllModelObjects:(NSString*)entityName sortKey:(NSString*)sortKeyName ascending:(BOOL)ascending;
@end


@implementation ModelManager

#pragma mark - Info
-(Info *)insertNewInfo
{
    return [self insertNewModelInstace:ENTITY_INFO];
}



#pragma mark - fetch object
-(NSArray*) getAllModelObjects:(NSString *)entityName sortKey:(NSString *)sortKeyName ascending:(BOOL)ascending
{
    NSManagedObjectContext *moc = [self managedObjectContext];
    if (moc == nil) {
        return nil;
    }
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    
    // Set predicate and sort orderings...
    if(sortKeyName != nil)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKeyName ascending:ascending];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil) {
        [[Logger Instance] Error:@"get all entity %@ failed: %@, %@", entityName, error, [error userInfo]];
        return nil;
    }
    
    return array;
}


- (NSArray*) getModelObjects:(NSString*)entityName withColumnName:(NSString*)colName columnValueString:(NSString*)colValue
{
    return [self getModelObjects:entityName withColumnName:colName columnValueString:colValue sortKey:nil ascending:YES];
}

- (NSArray*) getModelObjects:(NSString*)entityName withColumnName:(NSString*)colName columnValueString:(NSString*)colValue sortKey:(NSString *)sortKeyName ascending:(BOOL)ascending
{
    NSManagedObjectContext *moc = [self managedObjectContext];
    if (moc == nil) {
        return nil;
    }
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    
    // Set predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@ ",colName, colValue];
    [request setPredicate:predicate];
    if (sortKeyName != nil)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKeyName ascending:NO];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    return array;
}

- (id) getModelObject:(NSString*)entityName withIdName:(NSString*)idName idValueString:(NSString*)idValue {
    
    NSArray* array = [self getModelObjects:entityName withColumnName:idName columnValueString:idValue];
    
    if ([array count ]== 0) {
        return nil;
    } else {
        return [array objectAtIndex:0];
    }
    
}
- (NSArray*) getModelObjects:(NSString*)entityName withColumnName:(NSString*)colName columnValue:(NSInteger)colValue
{
    return [self getModelObjects:entityName withColumnName:colName columnValue:colValue sortKey:nil ascending:YES];
}

- (NSArray*) getModelObjects:(NSString*)entityName withColumnName:(NSString*)colName columnValue:(NSInteger)colValue sortKey:(NSString *)sortKeyName ascending:(BOOL)ascending
{
    return [self getModelObjects:entityName withColumnName:colName isEqualToValue:YES columnValue:colValue sortKey:sortKeyName ascending:ascending];
}

- (NSArray*) getModelObjects:(NSString*)entityName withColumnName:(NSString*)colName isEqualToValue:(BOOL)isEqual columnValue:(NSInteger)colValue sortKey:(NSString *)sortKeyName ascending:(BOOL)ascending
{
    NSManagedObjectContext *moc = [self managedObjectContext];
    if (moc == nil) {
        return nil;
    }
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    
    // Set predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:(isEqual ? @"%K == %d" : @"%K != %d") , colName, colValue];
    [request setPredicate:predicate];
    
    if (sortKeyName != nil)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKeyName ascending:ascending];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    return array;
}

- (id) getModelObject:(NSString*)entityName withIdName:(NSString*)idName idValue:(NSInteger)idValue {
    
    NSArray* array = [self getModelObjects:entityName withColumnName:idName columnValue:idValue];
    
    if ([array count ]== 0) {
        return nil;
    } else {
        return [array objectAtIndex:0];
    }
    
}

- (id) insertNewModelInstace:(NSString *)entityName {
    if (self.managedObjectContext == nil) {
        return nil;
    }
    
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
}

-(NSUInteger) countOfEntity:(NSString*)entityName withColumnName:(NSString*)colName columnValue:(NSInteger)colValue
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext]];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K == %d",colName, colValue];
    [request setPredicate:predicate];
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&err];
    if(count == NSNotFound)
    {
        [[Logger Instance] Error:@"get count of entity %@ failed: %@", entityName, err];
        return 0;
    }
    
    return count;
}




#pragma mark - init
- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

// Unit test will call this function to reset environment
+ (void) resetPersistentStoreCoordinator
{
    g_persistentStoreCoordinator = nil;
}

+ (NSString*) getPersistentFileName {
    return [[Utility cacheFolderForDB] stringByAppendingPathComponent:@"learndb.sqlite"];
}

+ (NSManagedObjectModel*) managedObjectModel {
    
    NSString* bundlePath = [[NSBundle bundleForClass:[ModelManager class]] bundlePath];
    NSString* modelFolder = [bundlePath stringByAppendingPathComponent:@"learndb.momd"];
    NSString* modelFile = [modelFolder stringByAppendingPathComponent:@"learndb.mom"];
    if ([Utility isFileExists:modelFile] == NO) {
        // For unit test
        modelFile = [bundlePath stringByAppendingPathComponent:@"learndb.mom"];
        if ([Utility isFileExists:modelFile] == NO) {
            [[Logger Instance] Error:@"Error: Cannot find model file: %@", modelFile];
            return nil;
        }
    }
    
    NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelFile]];
    
    return managedObjectModel;
}

+ (NSPersistentStoreCoordinator*) persistentStoreCoordinator {
    
    if (g_persistentStoreCoordinator == nil) {
        
        NSError* error;
        g_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, nil];
        if(! [g_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:[self getPersistentFileName]] options:options error:&error]) {
            [[Logger Instance] Error:@"Create stonefv.sqlite persistent store failed: %@, %@, %@", error, [error userInfo], [self getPersistentFileName]];
            g_persistentStoreCoordinator = nil;
        }
    }
    return g_persistentStoreCoordinator;
}

// Initialize global persistent store coordinator
+ (void)initModelPersistent {
    [self persistentStoreCoordinator];
}


- (NSString*) persistentFileName {
    return [ModelManager getPersistentFileName];
}

- (NSManagedObjectContext*) managedObjectContext
{
    if (_managedObjectContext == nil)
    {
        NSPersistentStoreCoordinator* coordinator =  [ModelManager persistentStoreCoordinator];
        if (coordinator)
        {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
            [_managedObjectContext setUndoManager:nil];
            //Fix NSMergeConflict issues http://stackoverflow.com/questions/19670429/ios7-nsmergeconflict-on-single-thread-save
            [_managedObjectContext setMergePolicy:[[NSMergePolicy alloc] initWithMergeType:NSMergeByPropertyObjectTrumpMergePolicyType]];
        }
        
    }
    return _managedObjectContext;
}

- (void)refreshObject:(NSManagedObject *)object mergeChanges:(BOOL)flag;
{
    if (_managedObjectContext != nil)
    {
        [_managedObjectContext refreshObject:object mergeChanges:flag];
    }
}

- (BOOL) save {
    NSError *error;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            
            [[Logger Instance] Error:@"Save position.sqllite error %@, %@", error, [error userInfo]];
            return NO;
        }
    }
    return YES;
}

-(void) deleteObject:(NSManagedObject*)object {
    if (_managedObjectContext != nil) {
        [_managedObjectContext deleteObject:object];
    }
}
@end
