//
//  SEHistoryTools.m
//  SieveOfEratosthenes
//
//  Created by orkenstein on 29.04.15.
//  Copyright (c) 2015 orkenstein. All rights reserved.
//

#import "SEHistoryTools.h"

@implementation SEHistoryItem

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [self init];
  if (self) {
    self.boundary = [aDecoder decodeIntegerForKey:@"boundary"];
    self.date = [aDecoder decodeObjectForKey:@"date"];
    self.numbers = [aDecoder decodeObjectForKey:@"numbers"];
    self.time = [aDecoder decodeDoubleForKey:@"time"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeInteger:self.boundary forKey:@"boundary"];
  [aCoder encodeObject:self.date forKey:@"date"];
  [aCoder encodeObject:self.numbers forKey:@"numbers"];
  [aCoder encodeDouble:self.time forKey:@"time"];
}

@end

@interface SEHistoryTools ()
@property (strong, nonatomic) NSMutableArray *mutableHistory;

@end

@implementation SEHistoryTools

+ (instancetype)sharedInstance {
  static dispatch_once_t pred = 0;
  __strong static SEHistoryTools *sharedObject = nil;
  dispatch_once(&pred, ^{
    sharedObject = [self new];
  });
  return sharedObject;
}

- (void)addHistoryItem:(SEHistoryItem *)item {
  [self.mutableHistory insertObject:item atIndex:0];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    [NSKeyedArchiver archiveRootObject:[self.mutableHistory copy] toFile:[SEHistoryTools historyPath]];
  });
}

- (NSArray *)historyItems {
  return [self.mutableHistory copy];
}

- (NSMutableArray *)mutableHistory {
  if (_mutableHistory == nil) {
    NSMutableArray *array = [[NSKeyedUnarchiver unarchiveObjectWithFile:[SEHistoryTools historyPath]] mutableCopy];
    if (array == nil) {
      array = [NSMutableArray array];
    }
    _mutableHistory = array;
  }
  return _mutableHistory;
}

+ (NSString *)historyPath {
  NSString *filepath =
  [(NSURL *)[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path];
  filepath = [filepath stringByAppendingPathComponent:@"historyFile"];
  return filepath;
}

@end
