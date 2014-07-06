//
//	CalendarViewController.h
//	DonatMG
//
//	Created by Goran Blažič on 29/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CalendarFieldView.h"

@interface CalendarViewController : UIViewController <CalendarFieldView> {
	NSDateComponents *_monthShown;
}

@property (nonatomic, strong) IBOutlet UIButton *leftButton;
@property (nonatomic, strong) IBOutlet UIButton *rightButton;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UILabel *mondayLabel;
@property (nonatomic, strong) IBOutlet UILabel *tuesdayLabel;
@property (nonatomic, strong) IBOutlet UILabel *wednesdayLabel;
@property (nonatomic, strong) IBOutlet UILabel *thursdayLabel;
@property (nonatomic, strong) IBOutlet UILabel *fridayLabel;
@property (nonatomic, strong) IBOutlet UILabel *saturdayLabel;
@property (nonatomic, strong) IBOutlet UILabel *sundayLabel;

@property (nonatomic, strong) IBOutlet UIView *containerView;

- (void)dayWasClicked:(NSUInteger)day;

@end
