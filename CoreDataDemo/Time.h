//
//  Time.h
//  CoreDataDemo
//
//  Created by YGuan on 16/4/23.
//  Copyright © 2016年 YGuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Time : NSManagedObject

@property (nullable, nonatomic, retain) NSDate *currentTime;

@end

