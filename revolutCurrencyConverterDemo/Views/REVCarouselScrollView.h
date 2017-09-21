//
//  REVCarouselScrollView.h
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 21/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol REVCarouselScrollViewDataSource;

@interface REVCarouselScrollView : UIScrollView

@property (nonatomic, weak) id<REVCarouselScrollViewDataSource> dataSource;

- (void)addMoneyArray:(NSArray<REVMoney *> *)moneyArray;

@end

@protocol REVCarouselScrollViewDataSource <NSObject>

- (UIView *)viewFromMoney:(REVMoney *)money atIndex:(NSInteger)i;
- (void)didPageAtIndex:(NSUInteger)index carouselView:(REVCarouselScrollView *)carouselView;

@end
