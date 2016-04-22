//
//  Person.h
//  CoreDataDemo
//
//  Created by YGuan on 16/4/22.
//  Copyright © 2016年 YGuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Person : NSManagedObject

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *age;

@end
