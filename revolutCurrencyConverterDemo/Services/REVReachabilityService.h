//
//  REVReachabilityService.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 17/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^REVReachabilityServiceCompletion)(BOOL isReachable);

@interface REVReachabilityService : NSObject

- (void)checkReachability:(REVReachabilityServiceCompletion)completion;

@end
