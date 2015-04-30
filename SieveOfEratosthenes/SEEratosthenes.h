//
//  SEEratosthenes.h
//  SieveOfEratosthenes
//
//  Created by orkenstein on 29.04.15.
//  Copyright (c) 2015 orkenstein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEEratosthenes : NSObject

+ (void)calculatePrimeNumbersWithBoundary:(NSInteger)boundary completionBlock:(void (^)(NSArray *numbers, NSTimeInterval time))completionBlock;

@end
