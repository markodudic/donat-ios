//
//	SettingsViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 01/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsManager.h"
#import "LanguageManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize containerView = _containerView;
@synthesize languageField = _languageField;
@synthesize saveButton = _saveButton;
@synthesize legalButton = _legalButton;
@synthesize legalLabel = _legalLabel;
@synthesize wakeLabel = _wakeLabel;
@synthesize wakeField = _wakeField;
@synthesize breakfastLabel = _breakfastLabel;
@synthesize breakfastField = _breakfastField;
@synthesize lunchLabel = _lunchLabel;
@synthesize lunchField = _lunchField;
@synthesize dinnerLabel = _dinnerLabel;
@synthesize dinnerField = _dinnerField;
@synthesize sleepLabel = _sleepLabel;
@synthesize sleepField = _sleepField;
@synthesize mealsLabel = _mealsLabel;
@synthesize mealsField = _mealsField;

- (void)setLanguageShown {
	LanguageManager *langManager = [LanguageManager sharedManager];
	self.languageField.text = [langManager languageForId:langManager.currentLangId];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view insertSubview:[[UIImageView alloc] initWithImage:
							  [UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]]
					 atIndex:0];

	self.saveButton.titleLabel.font = kSettingsButtonFont;
	self.legalLabel.font = kLegalFont;
	self.legalButton.titleLabel.font = kBoldTextFont;

	self.wakeLabel.font = kSettingsLabelFont;
	self.breakfastLabel.font = kSettingsLabelFont;
	self.lunchLabel.font = kSettingsLabelFont;
	self.dinnerLabel.font = kSettingsLabelFont;
	self.sleepLabel.font = kSettingsLabelFont;
	self.mealsLabel.font = kSettingsLabelFont;

	self.languageField.font = kSettingsLabelFont;
	self.languageField.tintColor = [UIColor clearColor];

	self.wakeField.font = kSettingsLabelFont;
	self.wakeField.tintColor = [UIColor clearColor];

	[self setLanguageShown];

	UIPickerView *languagePicker = [[UIPickerView alloc] init];
	languagePicker.dataSource = self;
	languagePicker.delegate = self;
	languagePicker.backgroundColor = [UIColor whiteColor];
	self.languageField.inputView = languagePicker;

	UIDatePicker *datePicker = [[UIDatePicker alloc] init];
	datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"sl"];
	datePicker.datePickerMode = UIDatePickerModeTime;
	datePicker.minuteInterval = 5;

	self.wakeField.inputView = datePicker;
	self.breakfastField.inputView = datePicker;
	self.lunchField.inputView = datePicker;
	self.dinnerField.inputView = datePicker;
	self.sleepField.inputView = datePicker;
}

- (IBAction)langaugeClick:(id)sender {
	[self.languageField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)setLanguageStrings {
	self.wakeLabel.text = ___(@"zbujanje");
	self.breakfastLabel.text = ___(@"zajtrk");
	self.lunchLabel.text = ___(@"kosilo");
	self.dinnerLabel.text = ___(@"vecerja");
	self.sleepLabel.text = ___(@"spanje");
	self.mealsLabel.text = ___(@"obrokov");

	self.legalLabel.text = ___(@"licence");
	[self.saveButton setTitle:___(@"save") forState:UIControlStateNormal];
	[self.legalButton setTitle:___(@"terms_of_use") forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// hide the title while view controller is visible
	self.title = @"";

	[self setLanguageStrings];
}

- (IBAction)legalPressed:(id)sender {
	[self performSegueWithIdentifier:@"showLegal" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// set the title so the "back" button will be shown with the appropriate title
	self.title = NSLocalizedString(@"settings_title", nil);
}

#pragma mark -
#pragma mark Editing responders

- (void)cancelEdit:(UIBarButtonItem *)sender {
	[_fieldBeingEdited resignFirstResponder];
}

- (void)doneEditing:(UIBarButtonItem *)sender {
	[_fieldBeingEdited resignFirstResponder];
}

#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 44.0f)];
	toolBar.barStyle = UIBarStyleBlackTranslucent;
	toolBar.tintColor = [UIColor darkGrayColor];

	UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ikona-zapri.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)];
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ikona-puscica_dol.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(doneEditing:)];
	[toolBar setItems:[NSArray arrayWithObjects:cancelBtn, flexibleItem, doneBtn, nil]];

	textField.inputAccessoryView = toolBar;

	_fieldBeingEdited = textField;

	return YES;
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [[LanguageManager sharedManager] languages].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[LanguageManager sharedManager] languages][row];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	NSString *language = [[LanguageManager sharedManager] languages][row];

	self.languageField.text = language;
	[self.languageField resignFirstResponder];

	NSString *localeId = [[LanguageManager sharedManager] idForLanguage:language];

	[[LanguageManager sharedManager] setLanguageId:localeId];

	[[SettingsManager sharedManager] setAppLanguage:localeId];

}

@end
