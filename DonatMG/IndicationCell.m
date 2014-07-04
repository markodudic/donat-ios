//
//	IndicationCell.m
//	DonatMG
//
//	Created by Goran Blažič on 29/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
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
}

- (void)setActive:(BOOL)active {
	_active = active;
	_activeIcon.hidden = !_active;
}

@end
