//
//  SEHistoryTools.h
//  SieveOfEratosthenes
//
//  Created by orkenstein on 29.04.15.
//  Copyright (c) 2015 orkenstein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEHistoryItem : NSObject <NSCoding>
@property (assign) NSInteger boundary;
@property (strong) NSDate *date;
@property (strong) NSArray *numbers;
@property (assign) NSTimeInterval time;

@end

@interface SEHistoryTools : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)historyItems;
- (void)addHistoryItem:(SEHistoryItem *)item;

@end
