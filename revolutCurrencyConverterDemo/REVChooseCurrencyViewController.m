//
//  REVChooseCurrencyViewController.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 16/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVChooseCurrencyViewController.h"
#import "REVCurrencyRateTimerServive.h"

@interface REVChooseCurrencyViewController ()

@end

@implementation REVChooseCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[REVCurrencyRateTimerServive shared] getRatesWithCompletion:^(NSArray<REVRate *> *rates, NSError *error) {
		NSLog(@"RATES:%@", rates);
	}];
}

@end
