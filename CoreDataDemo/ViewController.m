//
//  ViewController.m
//  CoreDataDemo
//
//  Created by YGuan on 16/4/21.
//  Copyright © 2016年 YGuan. All rights reserved.
//

#import "ViewController.h"
#import "LFZDataController.h"
#import "Person.h"
#import "NSManagedObject+Additions.h"

@interface ViewController ()

@property (strong, nonatomic) LFZDataController *dataController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataController = [LFZDataController standardController];
    
    Person *person = [Person lfz_insertNewObjectInManagedObjectContext:self.dataController.managedObjectContext];
    
    person.name = @"张三";
    person.age = @(24);
    
    [self.dataController saveContext];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
