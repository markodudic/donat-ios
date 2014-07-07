//
//	TreatmentManager.m
//	DonatMG
//
//	Created by Goran Blažič on 07/07/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "TreatmentManager.h"

@implementation TreatmentManager

#pragma mark Singleton Methods

+ (id)sharedManager {
	static TreatmentManager *sharedTreatmentManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedTreatmentManager = [[self alloc] init];
	});
	return sharedTreatmentManager;
}

- (id)init {
	if (self = [super init]) {
	}
	return self;
}

- (void)dealloc {
}

- (NSUInteger)numberOfInstructionsForIndication:(IndicationType)indication {
	switch (indication) {
		case kSrceOzilje:
		case kPocutje:
			return 1;
			break;
		case kZaprtost:
		case kDebelost:
		case kStres:
			return 2;
			break;
		case kZgaga:
		case kMagnezij:
		case kSladkorna:
		case kSlinavka:
			return 3;
			break;
		case kSecniKamni:
			return 4;
			break;
		default:
			return 0;
			break;
	}
}

@end
