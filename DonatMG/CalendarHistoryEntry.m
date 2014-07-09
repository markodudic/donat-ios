//
//	CalendarHistoryEntry.m
//	DonatMG
//
//	Created by Goran Blažič on 08/07/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "CalendarHistoryEntry.h"

@implementation CalendarHistoryEntry

@synthesize date = _date;
@synthesize indicationType = _indicationType;

- (id)init {
	if (self = [super init]) {
		_date = [NSDate date];
		_indicationType = kUnknown;
	}
	return self;
}

+ (id)entryWithDate:(NSDate *)date andIndicationType:(IndicationType)indicationType {
	return [[CalendarHistoryEntry alloc] initWithDate:date andIndicationType:indicationType];
}

- (id)initWithDate:(NSDate *)date andIndicationType:(IndicationType)indicationType {
	if (self = [super init]) {
		_date = date;
		_indicationType = indicationType;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		_date = [aDecoder decodeObjectForKey:@"date"];
		_indicationType = [aDecoder decodeIntegerForKey:@"indication"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_date forKey:@"date"];
	[aCoder encodeInteger:_indicationType forKey:@"indication"];
}

@end
