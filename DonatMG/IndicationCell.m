//
//	IndicationCell.m
//	DonatMG
//
//	Created by Goran Blažič on 02/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "IndicationCell.h"

@implementation IndicationCell

@synthesize imageView = _imageView;
@synthesize titleLabel = _titleLabel;
@synthesize activeIcon = _activeIcon;

@synthesize active = _active;

- (void)prepareForReuse {
	self.imageView.image = nil;
	self.titleLabel.text = @"";
	self.active = NO;

	// Just in case, if someone changes it
	// BUG: this doesn't seem to work when called from here, moving it to MainViewController tableView: cellForRowAtIndexPath:
//	[self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:15.0f]];
}

- (void)setActive:(BOOL)active {
	_active = active;
	_activeIcon.hidden = !_active;
}

@end
