//
//	IndicationViewController.h
//	DonatMG
//
//	Created by Goran Blažič on 29/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarHistoryEntry.h"

@interface IndicationViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate> {
	BOOL _amActive;

	BOOL _openHeader;
	BOOL _openDrink;
	BOOL _openDuration;

	CGFloat _desiredHeaderHeight;
	CGFloat _desiredDrinkHeight;
	CGFloat _desiredDurationHeight;

	UIDatePicker *_datePicker;
}

// TODO: This is a fugly hack... change!
@property (nonatomic, strong) IBOutlet UITextField *dummyField;

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) CalendarHistoryEntry *historyItem;

@property (atomic, assign) IndicationType indicationType;
@property (atomic, assign) BOOL justShowInfo;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UIView *headerPanel;
@property (nonatomic, strong) IBOutlet UIButton *headerButton;
@property (nonatomic, strong) IBOutlet UILabel *headerTitle;
@property (nonatomic, strong) IBOutlet UIImageView *headerIcon;
@property (nonatomic, strong) IBOutlet UITextView *headerLabel;

@property (nonatomic, strong) IBOutlet UIView *drinkPanel;
@property (nonatomic, strong) IBOutlet UIButton *drinkButton;
@property (nonatomic, strong) IBOutlet UILabel *drinkTitle;
@property (nonatomic, strong) IBOutlet UIView *drinkTableContainer;

@property (nonatomic, strong) IBOutlet UIView *durationPanel;
@property (nonatomic, strong) IBOutlet UIButton *durationButton;
@property (nonatomic, strong) IBOutlet UILabel *durationTitle;
@property (nonatomic, strong) IBOutlet UILabel *durationLabel;

@property (nonatomic, strong) IBOutlet UIView *startPanel;
@property (nonatomic, strong) IBOutlet UILabel *startTitle;
@property (nonatomic, strong) IBOutlet UIButton *dayButton;
@property (nonatomic, strong) IBOutlet UIButton *monthButton;
@property (nonatomic, strong) IBOutlet UIButton *yearButton;
@property (nonatomic, strong) IBOutlet UIButton *bigButton;

@end
