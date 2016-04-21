//
//  ViewController.m
//  CoreDataDemo
//
//  Created by YGuan on 16/4/21.
//  Copyright © 2016年 YGuan. All rights reserved.
//

#import "ViewController.h"
#import "LFZDataController.h"

@interface ViewController ()

@property (strong, nonatomic) LFZDataController *dataController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataController = [LFZDataController standardController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
