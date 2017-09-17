//
//  REVReachabilityService.m
//  revolutCurrencyConverterDemo
//
//  Created by andrey on 17/09/2017.
//  Copyright © 2017 lebedac. All rights reserved.
//

#import "REVReachabilityService.h"
#import "Reachability.h"
#import "REVCurrencyRateAPIService.h"

@interface REVReachabilityService ()
@property (nonatomic, strong) REVReachabilityServiceCompletion completion;

@property (nonatomic, strong) Reachability *hostReachability;
@property (nonatomic, strong) Reachability *internetReachability;

@property (nonatomic, assign) NSInteger prevNetworkStatus;
@end

@implementation REVReachabilityService

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(reachabilityChanged:)
													 name:kReachabilityChangedNotification
												   object:nil];
		_prevNetworkStatus = -1;
	}
	return self;
}

- (void)checkReachability:(REVReachabilityServiceCompletion)completion {
	if (!completion) {
		return;
	}
	self.completion = completion;
	
	NSURL *URL = [NSURL URLWithString:REVRateURLString];
	NSString *host = URL.host;
	self.hostReachability = [Reachability reachabilityWithHostName:host];
	[self.hostReachability startNotifier];
	[self updateReachabilityWithStatus:[self.hostReachability currentReachabilityStatus]];
	
	self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	[self updateReachabilityWithStatus:[self.internetReachability currentReachabilityStatus]];
}

- (void)reachabilityChanged:(NSNotification *)notification {
	Reachability* curReach = [notification object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateReachabilityWithStatus:[curReach currentReachabilityStatus]];
}

- (void)updateReachabilityWithStatus:(NetworkStatus)status {
	switch (status) {
		case NotReachable:{
			if (self.prevNetworkStatus != status || self.prevNetworkStatus == -1) {
				self.completion(NO);
			}
			break;
		}
		case ReachableViaWiFi: {
			if (self.prevNetworkStatus == NotReachable || self.prevNetworkStatus == -1) {
				self.completion(YES);
			}
			break;
		}
		case ReachableViaWWAN: {
			if (self.prevNetworkStatus == NotReachable || self.prevNetworkStatus == -1) {
				self.completion(YES);
			}
			break;
		}
	}
	self.prevNetworkStatus = status;
}

@end
