//
//  NSManagedObject+Additions.h
//  CoreDataDemo
//
//  Created by YGuan on 16/4/22.
//  Copyright © 2016年 YGuan. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Additions)

+ (NSString *)lfz_entityName;

+ (instancetype)lfz_insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)context;

@end
