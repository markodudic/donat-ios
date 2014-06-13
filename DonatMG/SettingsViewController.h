//
//	SettingsViewController.h
//	DonatMG
//
//	Created by Goran Blažič on 01/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {

	UITextField *_fieldBeingEdited;
	BOOL _amEditingLanguage;

	UIPickerView *_picker;
	UIDatePicker *_datePicker;

	BOOL _shouldSave;
}

@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UITextField *languageField;

@property (nonatomic, strong) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) IBOutlet UIButton *legalButton;
@property (nonatomic, strong) IBOutlet UILabel *legalLabel;

@property (nonatomic, strong) IBOutlet UILabel *wakeLabel;
@property (nonatomic, strong) IBOutlet UITextField *wakeField;
@property (nonatomic, strong) IBOutlet UILabel *breakfastLabel;
@property (nonatomic, strong) IBOutlet UITextField *breakfastField;
@property (nonatomic, strong) IBOutlet UILabel *lunchLabel;
@property (nonatomic, strong) IBOutlet UITextField *lunchField;
@property (nonatomic, strong) IBOutlet UILabel *dinnerLabel;
@property (nonatomic, strong) IBOutlet UITextField *dinnerField;
@property (nonatomic, strong) IBOutlet UILabel *sleepLabel;
@property (nonatomic, strong) IBOutlet UITextField *sleepField;
@property (nonatomic, strong) IBOutlet UILabel *mealsLabel;
@property (nonatomic, strong) IBOutlet UITextField *mealsField;

@end
