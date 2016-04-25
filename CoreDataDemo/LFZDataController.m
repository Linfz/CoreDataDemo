//
//  LFZDataController.m
//  CoreDataDemo
//
//  Created by YGuan on 16/4/21.
//  Copyright © 2016年 YGuan. All rights reserved.
//

#import "LFZDataController.h"
#import "Time.h"

@interface LFZDataController ()

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *writeManagedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation LFZDataController

#pragma mark- initialize

+(instancetype)standardController {
    static dispatch_once_t onceToken;
    static LFZDataController *controller = nil;
    _dispatch_once(&onceToken, ^{
        controller = [[self alloc]init];
    });
    return controller;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self initializeCoreData];
    
    return self;
}

- (void)initializeCoreData
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataDemo" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    self.writeManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [self.writeManagedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.managedObjectContext setParentContext:self.writeManagedObjectContext];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"CoreDataDemo.sqlite"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    });
}

#pragma mark- pravite method

- (void(^)())saveWriteContextBlockWithCompletion:(void (^)(NSError *))completion {
    
    void (^saveWrite)(void) = ^{
        NSError *error = nil;
        if ([self.writeManagedObjectContext save:&error] == NO) {
            if (completion) {
                completion(error);
            }
        } else {
            if (completion) {
                completion(nil);
            }
        }
    };
    return saveWrite;
}


- (BOOL)managedObjectContextHasChanges:(NSManagedObjectContext *)context {
    __block BOOL hasChanges;
    [context performBlockAndWait:^{
        hasChanges = [context hasChanges];
    }];
    
    return hasChanges;
}


#pragma mark- public method

- (NSArray *)loadAllItems {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Time class])];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"currentTime" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    [request setPredicate:nil];
    
    NSError *error = nil;
    NSArray *objs = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    return objs;
}

- (void)deleteObject:(NSManagedObject *)object {
    id obj = [self.managedObjectContext objectWithID:object.objectID];
    if (obj) {
        [self.managedObjectContext deleteObject:obj];
    }
}

- (void)saveContextSync:(BOOL)sync completion:(void (^)(NSError *error))completion {
    
    if ([self managedObjectContextHasChanges:self.managedObjectContext] || [self managedObjectContextHasChanges:self.writeManagedObjectContext]) {
        [self.managedObjectContext performBlockAndWait:^{
            NSError *mainContextSaveError = nil;
            if ([self.managedObjectContext save:&mainContextSaveError] == NO) {
                if (completion) {
                    completion(mainContextSaveError);
                }
                return;
            }
            if ([self managedObjectContextHasChanges:self.writeManagedObjectContext]) {
                if (sync) {
                    [self.writeManagedObjectContext performBlockAndWait:[self saveWriteContextBlockWithCompletion:completion]];
                } else {
                    [self.writeManagedObjectContext performBlock:[self saveWriteContextBlockWithCompletion:completion]];
                }
                return;
            }
            if (completion) {
                completion(nil);
            }
        }];
    } else {
        if (completion) {
            completion(nil);
        }
    }
}


@end
