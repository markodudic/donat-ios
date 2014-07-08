//
//	InsetLabel.m
//	DonatMG
//
//	Created by Goran Blažič on 08/07/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "InsetLabel.h"

@implementation InsetLabel

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	}
	return self;
}

- (void)drawTextInRect:(CGRect)rect {
	[super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
