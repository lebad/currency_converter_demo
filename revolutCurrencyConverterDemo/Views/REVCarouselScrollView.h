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
- (void)scrollToPage:(NSUInteger)page;

@end

@protocol REVCarouselScrollViewDataSource <NSObject>

- (NSUInteger)numberOfItemsForCarouselView:(REVCarouselScrollView *)carouselView;
- (UIView *)objectAtIndex:(NSUInteger)objectIndex carouselView:(REVCarouselScrollView *)carouselView;
- (void)didPageAtIndex:(NSUInteger)index carouselView:(REVCarouselScrollView *)carouselView;
- (void)didViewAtIndex:(NSUInteger)index carouselView:(REVCarouselScrollView *)carouselView;
- (void)dataIsLoadedForCarouselView:(REVCarouselScrollView *)carouselView;

@end
