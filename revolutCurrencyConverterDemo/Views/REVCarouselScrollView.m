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
	
	CGFloat yOrigin = 0;
	CGRect containerFrame = CGRectMake(0, yOrigin, scrollViewWidth, scrollViewHeight);
	
	UIView *lastMoneyView = [self.dataSource objectAtIndex:self.count-1 carouselView:self];
	lastMoneyView.frame = containerFrame;
	[self addSubview:lastMoneyView];
	
	for (NSInteger i=0; i<self.count; i++) {
		UIView *moneyView = [self.dataSource objectAtIndex:i carouselView:self];
		containerFrame = CGRectMake(scrollViewWidth*(i+1), yOrigin, scrollViewWidth, scrollViewHeight);
		moneyView.frame = containerFrame;
		[self addSubview:moneyView];
	}
	UIView *firstMoneyView = [self.dataSource objectAtIndex:0 carouselView:self];
	containerFrame = CGRectMake(scrollViewWidth*(self.count+1), yOrigin, scrollViewWidth, scrollViewHeight);
	firstMoneyView.frame = containerFrame;
	[self addSubview:firstMoneyView];
	
	self.contentSize = CGSizeMake(scrollViewWidth*(self.count+2), scrollViewHeight);
	
	//default scroll to the second
	[self scrollRectToVisible:CGRectMake(scrollViewWidth,0,scrollViewWidth,scrollViewHeight) animated:NO];
	[self.dataSource dataIsLoadedForCarouselView:self];
	[self scrollViewDidEndDecelerating:self];
}

- (void)setup {
	self.translatesAutoresizingMaskIntoConstraints = NO;
	self.pagingEnabled = YES;
	self.showsHorizontalScrollIndicator = NO;
	self.showsVerticalScrollIndicator = NO;
	self.delegate = self;
}

- (void)scrollToPage:(NSUInteger)page {
	CGFloat scrollViewWidth = CGRectGetWidth(self.frame);
	CGFloat scrollViewHeight = CGRectGetHeight(self.frame);
	
	CGFloat xOrigin = scrollViewWidth*(page+1);
	
	[self scrollRectToVisible:CGRectMake(xOrigin,0,scrollViewWidth,scrollViewHeight) animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat scrollViewWidth = CGRectGetWidth(self.frame);
	CGFloat scrollViewHeight = CGRectGetHeight(self.frame);
	
	if ([self isLastElement]) {
		//scroll to the second
		[self scrollRectToVisible:CGRectMake(scrollViewWidth,0,scrollViewWidth,scrollViewHeight) animated:NO];
	}
	if ([self isFirstElement]) {
		//scroll to the last but one
		[self scrollRectToVisible:CGRectMake(scrollViewWidth * self.count,0,scrollViewWidth,scrollViewHeight) animated:NO];
	}
	
	int currentPage = floor((self.contentOffset.x - self.frame.size.width / (self.count+2)) / self.frame.size.width);
	
	if ([self isFirstElement]) {
		[self.dataSource didViewAtIndex:0 carouselView:self];
	} else if ([self isLastElement]) {
		[self.dataSource didViewAtIndex:self.count+1 carouselView:self];
	} else {
		[self.dataSource didViewAtIndex:currentPage+1 carouselView:self];
	}
	
	[self.dataSource didPageAtIndex:currentPage carouselView:self];
}

- (BOOL)isLastElement {
	CGFloat scrollViewWidth = CGRectGetWidth(self.frame);
	return self.contentOffset.x == scrollViewWidth*(self.count+1);
}

- (BOOL)isFirstElement {
	return self.contentOffset.x == 0;
}

@end
