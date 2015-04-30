//
//  ViewController.m
//  SieveOfEratosthenes
//
//  Created by orkenstein on 29.04.15.
//  Copyright (c) 2015 orkenstein. All rights reserved.
//

#import "SEViewController.h"
#import "SENumberCell.h"
#import "SEEratosthenes.h"
#import "SEHistoryTools.h"
#import "SEHistoryController.h"

@interface SEViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *boundaryTextField;
@property (weak, nonatomic) IBOutlet UIButton *runButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong) NSArray *numbers;

@end

@implementation SEViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self updateHistoryButton];
  
  SEHistoryItem *lastItem = [[[SEHistoryTools sharedInstance] historyItems] firstObject];
  [self updateForItem:lastItem];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)updateForItem:(SEHistoryItem *)item {
  self.boundaryTextField.text = [@(item.boundary) stringValue];
  self.numbers = item.numbers;
  
  [self.collectionView reloadData];
}

- (void)updateHistoryButton {
  self.historyButton.enabled = [[SEHistoryTools sharedInstance] historyItems].count != 0;
}

#pragma mark - Actions

- (IBAction)runButtonAction:(id)sender {
  self.runButton.hidden = YES;
  [self.activityIndicator startAnimating];
  [self.boundaryTextField resignFirstResponder];
  __weak SEViewController *weakSelf = self;
  NSInteger boundary = self.boundaryTextField.text.integerValue;
  [SEEratosthenes calculatePrimeNumbersWithBoundary:boundary
                                    completionBlock:^(NSArray *numbers, NSTimeInterval time) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                        weakSelf.runButton.hidden = NO;
                                        [weakSelf.activityIndicator stopAnimating];
                                        weakSelf.numbers = numbers;
                                        [weakSelf.collectionView reloadData];
                                        
                                        //  Add to history
                                        SEHistoryItem *item = [SEHistoryItem new];
                                        item.boundary = boundary;
                                        item.date = [NSDate date];
                                        item.numbers = numbers;
                                        item.time = time;
                                        [[SEHistoryTools sharedInstance] addHistoryItem:item];
                                        
                                        [weakSelf updateHistoryButton];
                                      });
                                    }];
}

- (IBAction)historyButtonAction:(id)sender {
  SEHistoryController *historyVC = [[SEHistoryController alloc] init];
  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:historyVC];
  [self presentViewController:navVC animated:YES completion:nil];
  
  __weak SEViewController *weakSelf = self;
  [historyVC setSelectBlock:^(SEHistoryItem *item) {
    [weakSelf updateForItem:item];
  }];
}

#pragma mark - Colection Delegate & Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.numbers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SENumberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kNumberCell" forIndexPath:indexPath];
  cell.numberLabel.text = [self.numbers[indexPath.row] stringValue];
  return cell;
}

@end
