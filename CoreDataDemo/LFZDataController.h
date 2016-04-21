//
//  LFZDataController.h
//  CoreDataDemo
//
//  Created by YGuan on 16/4/21.
//  Copyright © 2016年 YGuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LFZDataController : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+(instancetype)standardController;

@end
