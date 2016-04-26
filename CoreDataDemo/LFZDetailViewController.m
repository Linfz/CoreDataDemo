//
//  LFZDetailViewController.m
//  CoreDataDemo
//
//  Created by YGuan on 16/4/26.
//  Copyright © 2016年 YGuan. All rights reserved.
//

#import "LFZDetailViewController.h"
#import "LFZDataController.h"
#import "Time.h"

@interface LFZDetailViewController ()

@property (strong, nonatomic) UILabel *detailLabel;

@end

@implementation LFZDetailViewController

- (UILabel *)detailLabel {
    if (_detailLabel != nil) {
        return _detailLabel;
    }
    _detailLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    return _detailLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.detailLabel];
    self.detailLabel.text = self.time.currentTime.description;
    
    UIBarButtonItem *deleteBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteCurrentItem:)];
    
    UIBarButtonItem *refreshBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshCurrentItem:)];
    
    self.navigationItem.rightBarButtonItems = @[refreshBarItem, deleteBarItem];
    
}

- (void)deleteCurrentItem:(id)sender {
    [[LFZDataController standardController] deleteObject:self.time];
    [[LFZDataController standardController] saveContextSync:YES completion:^(NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)refreshCurrentItem:(id)sender {
    self.time.currentTime = [NSDate date];
    [[LFZDataController standardController] saveContextSync:YES completion:^(NSError *error) {
        self.detailLabel.text = self.time.currentTime.description;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
