//
//  ViewController.m
//  CoreDataDemo
//
//  Created by YGuan on 16/4/21.
//  Copyright © 2016年 YGuan. All rights reserved.
//

#import "ViewController.h"
#import "LFZDataController.h"
#import "Time.h"
#import "NSManagedObject+Additions.h"

@interface ViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LFZDataController *dataController;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation ViewController

#pragma mark- life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataController = [LFZDataController standardController];
    self.dataSource = [NSMutableArray arrayWithArray:[self.dataController loadAllItems]];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if (self.tableView.editing) {
        self.tableView.editing = !editing;
    }else {
        self.tableView.editing = editing;
    }
}

#pragma mark- button action

- (IBAction)insertNewObject:(id)sender {
    Time *time = [Time lfz_insertNewObjectInManagedObjectContext:self.dataController.managedObjectContext];
    time.currentTime = [NSDate date];
    
    __weak typeof (self) weakSelf = self;
    [self.dataController saveContextSync:YES completion:^(NSError *error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.dataSource insertObject:time atIndex:0];
        [strongSelf.tableView beginUpdates];
        [strongSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [strongSelf.tableView endUpdates];
    }];
}

#pragma mark- tableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    return cell;
}

#pragma mark- tableView Delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Time *time = self.dataSource[indexPath.row];
    cell.textLabel.text = time.currentTime.description;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Time *time = self.dataSource[indexPath.row];
    [self.dataSource removeObject:time];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self.dataController deleteObject:time];
    [self.dataController saveContextSync:NO completion:nil];
}


@end
