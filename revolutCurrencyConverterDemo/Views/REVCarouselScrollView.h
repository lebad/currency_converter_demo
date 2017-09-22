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
- (void)reloadData;

@end

@protocol REVCarouselScrollViewDataSource <NSObject>

- (NSUInteger)numberOfItemsForCarouselView:(REVCarouselScrollView *)carouselView;
- (UIView *)objectAtIndex:(NSUInteger)objectIndex viewAtIndex:(NSUInteger)viewIndex carouselView:(REVCarouselScrollView *)carouselView;
- (void)didPageAtIndex:(NSUInteger)index carouselView:(REVCarouselScrollView *)carouselView;

@end
