//
//  SEHistoryController.m
//  SieveOfEratosthenes
//
//  Created by orkenstein on 29.04.15.
//  Copyright (c) 2015 orkenstein. All rights reserved.
//

#import "SEHistoryController.h"

@interface SEHistoryController ()

@end

@implementation SEHistoryController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.leftBarButtonItem =
  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
}

- (void)doneAction {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[SEHistoryTools sharedInstance] historyItems].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifier"];
  
  SEHistoryItem *item = [[SEHistoryTools sharedInstance] historyItems][indexPath.row];
  cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@ prime (%@ sec.)", [@(item.boundary) stringValue],
                         [@(item.numbers.count) stringValue], [@(item.time) stringValue]];
  cell.detailTextLabel.text =
  [NSDateFormatter localizedStringFromDate:item.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  SEHistoryItem *item = [[SEHistoryTools sharedInstance] historyItems][indexPath.row];
  
  if (self.selectBlock) {
    self.selectBlock(item);
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
