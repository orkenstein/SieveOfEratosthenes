//
//  SEEratosthenes.m
//  SieveOfEratosthenes
//
//  Created by orkenstein on 29.04.15.
//  Copyright (c) 2015 orkenstein. All rights reserved.
//

#import "SEEratosthenes.h"

NSInteger const KMaxBlocks = 10;

@implementation SEEratosthenes

+ (void)calculatePrimeNumbersWithBoundary:(NSInteger)boundary completionBlock:(void (^)(NSArray *, NSTimeInterval))completionBlock {
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
    NSLog(@"Start calculation");
    NSDate *startDate = [NSDate date];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:boundary + 1];
    
    for (NSInteger index = 0; index <= boundary; index++) {
      [array addObject:@1];
    }
    //  skip 0, 1 and even numbers
    array[0] = @0;
    array[1] = @0;
    for (NSInteger index = 4; index <= boundary; index += 2) {
      array[index] = @0;
    }
    
    NSInteger numberOfDispatchedBlocks = 0;
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger index_i = 3; index_i <= boundary; index_i += 2) {
      if ([array[index_i] integerValue] == 1) {
        
        void (^block)() = ^() {
          for (NSInteger index_j = index_i; (index_i * index_j) <= boundary; index_j += 2) {
            array[(index_i * index_j)] = @0;
          }
        };
        
        if (numberOfDispatchedBlocks < KMaxBlocks) {
          dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block);
          //  Takes really long time
          //          NSLog(@"Block %ld dispatched to group", (long)numberOfDispatchedBlocks);
          numberOfDispatchedBlocks++;
        } else {
          block();
          //  Takes really long time
          //          NSLog(@"Block executed directly");
        }
      }
    }
    
    NSLog(@"Wait for %@ blocks", @(numberOfDispatchedBlocks));
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"Group done");
    
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:startDate];
    NSLog(@"Total time: %@", @(time));
    
    if (completionBlock) {
      NSMutableArray *resultArray = [NSMutableArray array];
      for (NSInteger index = 0; index <= boundary; index++) {
        if ([array[index] integerValue] == 1) {
          [resultArray addObject:@(index)];
        }
      }
      completionBlock(resultArray, time);
    }
  });
}

@end
