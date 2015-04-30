//
//  SEHistoryController.h
//  SieveOfEratosthenes
//
//  Created by orkenstein on 29.04.15.
//  Copyright (c) 2015 orkenstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEHistoryTools.h"

@interface SEHistoryController : UITableViewController
@property (strong) void (^selectBlock)(SEHistoryItem *historyItem);

@end
