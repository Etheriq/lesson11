//
//  FibonachiManager.m
//  Threads
//
//  Created by Yuriy T on 30.01.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "FibonachiManager.h"

@implementation FibonachiManager

+(NSDecimalNumber*) calculateFib: (NSInteger) n {
    
    @autoreleasepool {
        NSDecimalNumber *fib = [[NSDecimalNumber alloc] initWithDouble:pow((1 + sqrt(5)) / 2, n) / sqrt(5) + 0.5f];
        
        return fib;
    }
}

@end
