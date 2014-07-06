//
//	CalendarFieldView.h
//	DonatMG
//
//	Created by Goran Blažič on 06/07/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarFieldView <NSObject>

- (void)dayWasClicked:(NSUInteger)day;

@end

@interface CalendarFieldView : UIView {
	UIImageView *_glassIcon;
	UIImageView *_todayIcon;
	UIButton *_numberButton;
}

@property id <CalendarFieldView> delegate;

@property (nonatomic, assign) BOOL today;
@property (nonatomic, assign) NSUInteger day;
@property (nonatomic, assign) BOOL hasDrunk;

@end