//
//  REVCarouselScrollView.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 21/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVCarouselScrollView.h"

@interface REVCarouselScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray<REVMoney *> *moneyArray;

@end

@implementation REVCarouselScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_moneyArray = [NSArray array];
		[self setup];
	}
	return self;
}

- (void)addMoneyArray:(NSArray<REVMoney *> *)moneyArray {
	self.moneyArray = moneyArray;
	
	CGFloat scrollViewWidth = CGRectGetWidth(self.frame);
	CGFloat scrollViewHeight = CGRectGetHeight(self.frame);
	NSUInteger count = 0;
	
	REVMoney *lastMoney = self.moneyArray.lastObject;
	UIView *lastMoneyView = [self.dataSource viewFromMoney:lastMoney atIndex:0];
	[self addSubview:lastMoneyView];
	
	for (NSInteger i=0; i<self.moneyArray.count; i++) {
		REVMoney *money = self.moneyArray[i];
		UIView *moneyView = [self.dataSource viewFromMoney:money atIndex:i+1];
		[self addSubview:moneyView];
		count ++;
	}
	REVMoney *firstMoney = self.moneyArray.firstObject;
	UIView *firstMoneyView = [self.dataSource viewFromMoney:firstMoney atIndex:count+1];
	[self addSubview:firstMoneyView];
	
	self.contentSize = CGSizeMake(scrollViewWidth*(count+2), scrollViewHeight);
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
	CGFloat scrollViewWidth = CGRectGetWidth(scrollView.frame);
	CGFloat scrollViewHeight = CGRectGetHeight(scrollView.frame);
	
	int currentPage = floor((scrollView.contentOffset.x - scrollView.frame.size.width / ([self.moneyArray count]+2)) / scrollView.frame.size.width) + 1;
	if (currentPage==0) {
		//go last but 1 page
		[scrollView scrollRectToVisible:CGRectMake(scrollViewWidth * [self.moneyArray count],0,scrollViewWidth,scrollViewHeight) animated:NO];
	} else if (currentPage==([self.moneyArray count]+1)) {
		[scrollView scrollRectToVisible:CGRectMake(scrollViewWidth,0,scrollViewWidth,scrollViewHeight) animated:NO];
	}
	
	CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
	int currentPageForControll = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
	NSUInteger currentPageMoney = currentPageForControll==3 ? 0 : currentPageForControll;
	[self.dataSource didPageAtIndex:currentPageMoney carouselView:self];
}

@end
