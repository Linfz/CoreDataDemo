//
//  NSManagedObject+Additions.m
//  CoreDataDemo
//
//  Created by YGuan on 16/4/22.
//  Copyright © 2016年 YGuan. All rights reserved.
//

#import "NSManagedObject+Additions.h"

@implementation NSManagedObject (Additions)

+ (NSString *)lfz_entityName {
    return NSStringFromClass([self class]);
}

+ (instancetype)lfz_insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription insertNewObjectForEntityForName:[self lfz_entityName] inManagedObjectContext:context];
}

@end
