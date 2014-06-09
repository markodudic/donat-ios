//
//	SettingsViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 01/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "SettingsViewController.h"
#import "LanguageManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize scrollView = _scrollView;
@synthesize languageLabel = _languageLabel;

- (NSUInteger)addIconToViewAtTop:(NSUInteger)top withImage:(NSString *)image {
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];

	CGRect parent = _scrollView.frame;
	CGRect frame = imgView.frame;
	frame.origin.y = top;
	frame.origin.x = (parent.size.width - frame.size.width) / 2.0f;
	imgView.frame = frame;

	[_scrollView addSubview:imgView];

	return frame.size.height;
}

- (NSUInteger)addLanguageSelectorAtTop:(NSUInteger)top withLabel:(UILabel *)label {
	CGFloat height = label.frame.size.height + 20.0f;

	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20.0f, top, _scrollView.frame.size.width - 40.0f, height)];

	view.layer.backgroundColor = [UIColor whiteColor].CGColor;
	view.layer.borderColor = kSelectionBorderColor.CGColor;
	view.layer.borderWidth = kSelectionBorderWidth;

	[_scrollView addSubview:view];

	label.frame = CGRectMake(10.0f, 10.0f, view.frame.size.width - 20.0f, height - 20.0f);
	[view addSubview:label];

	return view.frame.size.height;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view insertSubview:[[UIImageView alloc] initWithImage:
							  [UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]]
					 atIndex:0];

	CGFloat top = 0.0f;

	UIView *redBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, top, _scrollView.frame.size.width, 2.0f)];
	redBar.backgroundColor = [UIColor redColor];
	[_scrollView addSubview:redBar];
	top += redBar.frame.size.height + 10.0f;

	top += [self addIconToViewAtTop:top withImage:@"icon_jezik.png"] + 10.0f;

	_languageLabel = [[UILabel alloc] init];
	_languageLabel.font = kTextFont;
	_languageLabel.text = ___(@"language_name");

	CGSize maxSize = CGSizeMake(_scrollView.frame.size.width - 60.0f, MAXFLOAT);
	CGRect labelRect = [_languageLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_languageLabel.font} context:nil];
	_languageLabel.frame = CGRectMake(0.0f, 0.0f, _scrollView.frame.size.width - 60.0f, labelRect.size.height);

	top += [self addLanguageSelectorAtTop:top withLabel:_languageLabel] + 10.0f;

	top += [self addIconToViewAtTop:top withImage:@"icon_ure.png"] + 10.0f;

	_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, top);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// hide the title while view controller is visible
	self.title = @"";
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// set the title so the "back" button will be shown with the appropriate title
	self.title = NSLocalizedString(@"settingsTitle", nil);
}

@end
