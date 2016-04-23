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
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation LFZDataController

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
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    [self setManagedObjectContext:moc];
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

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.YGuan.CoreDataDemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

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

- (void)saveContext {
    NSError *error = nil;
    if([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
        abort();
    }
}


@end
