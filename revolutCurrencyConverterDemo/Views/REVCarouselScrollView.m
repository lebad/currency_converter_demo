//
//  REVCarouselScrollView.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 21/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVCarouselScrollView.h"

@interface REVCarouselScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger count;

@end

@implementation REVCarouselScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_count = 0;
		[self setup];
	}
	return self;
}

- (void)reloadData
{
	self.count = [self.dataSource numberOfItemsForCarouselView:self];
	
	CGFloat scrollViewWidth = CGRectGetWidth(self.frame);
	CGFloat scrollViewHeight = CGRectGetHeight(self.frame);
	
	UIView *lastMoneyView = [self.dataSource objectAtIndex:self.count-1 viewAtIndex:0 carouselView:self];
	[self addSubview:lastMoneyView];
	
	for (NSInteger i=0; i<self.count; i++) {
		UIView *moneyView = [self.dataSource objectAtIndex:i viewAtIndex:i+1 carouselView:self];
		[self addSubview:moneyView];
	}
	UIView *firstMoneyView = [self.dataSource objectAtIndex:0 viewAtIndex:self.count+1 carouselView:self];
	[self addSubview:firstMoneyView];
	
	self.contentSize = CGSizeMake(scrollViewWidth*(self.count+2), scrollViewHeight);
	
	//default scroll to the second
	[self scrollRectToVisible:CGRectMake(scrollViewWidth,0,scrollViewWidth,scrollViewHeight) animated:NO];
	[self.dataSource didPageAtIndex:0 carouselView:self];
}

- (void)setup {
	self.translatesAutoresizingMaskIntoConstraints = NO;
	self.pagingEnabled = YES;
	self.showsHorizontalScrollIndicator = NO;
	self.showsVerticalScrollIndicator = NO;
	self.delegate = self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat scrollViewWidth = CGRectGetWidth(self.frame);
	CGFloat scrollViewHeight = CGRectGetHeight(self.frame);
	
	//when last element
	if (self.contentOffset.x == scrollViewWidth*(self.count+1)) {
		//scroll to the second
		[self scrollRectToVisible:CGRectMake(scrollViewWidth,0,scrollViewWidth,scrollViewHeight) animated:NO];
	}
	//when first element
	if (self.contentOffset.x == 0) {
		//scroll to the last but one
		[self scrollRectToVisible:CGRectMake(scrollViewWidth * self.count,0,scrollViewWidth,scrollViewHeight) animated:NO];
	}
	
	int currentPage = floor((self.contentOffset.x - self.frame.size.width / (self.count+2)) / self.frame.size.width);
	[self.dataSource didPageAtIndex:currentPage carouselView:self];
	
}

@end
