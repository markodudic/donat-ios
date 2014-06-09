//
//	MainViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 01/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsManager.h"
#import "IndicationCell.h"
#import "IndicationViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize headerView = _headerView;
@synthesize headerLabel = _headerLabel;

- (void)calendar {
	[self performSegueWithIdentifier:@"showCalendar" sender:self];
}

- (void)settings {
	[self performSegueWithIdentifier:@"showSettings" sender:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]];

	UIBarButtonItem *calendarItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"calendar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(calendar)];
	UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"settings.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settings)];
	NSArray *buttonsArray = @[settingsItem, calendarItem];
	self.navigationItem.rightBarButtonItems = buttonsArray;

	UIImage *image = [[UIImage imageNamed:@"moments-title.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
	barButton.customView = [[UIImageView alloc] initWithImage:image];
	self.navigationItem.leftBarButtonItem = barButton;

	[self.headerLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14.0f]];

	[self.headerLabel setText:___(@"home_screen_title")];

	CGSize maxSize = CGSizeMake(self.headerView.frame.size.width - 40.0f, MAXFLOAT);
	CGRect labelRect = [self.headerLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.headerLabel.font} context:nil];

	CGRect viewRect = self.headerView.frame;

	viewRect.size = CGSizeMake(viewRect.size.width, labelRect.size.height + 20.0f);
	[self.headerView setFrame:viewRect];

	[self.headerLabel removeFromSuperview];
	labelRect.origin = CGPointMake(20.0f, 10.0f);
	[self.headerLabel setFrame:labelRect];
	[self.headerView addSubview:self.headerLabel];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// hide the title while view controller is visible
	self.title = @"";

	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	IndicationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"indicationCell" forIndexPath:indexPath];

	// our indications start from 1
	switch (indexPath.item + 1) {
		case kZaprtost:
			cell.tag = kZaprtost;
			cell.imageView.image = [UIImage imageNamed:@"icon_zaprtost.png"];
			cell.titleLabel.text = ___(@"indication_1");
			break;
		case kZgaga:
			cell.tag = kZgaga;
			cell.imageView.image = [UIImage imageNamed:@"icon_zgaga.png"];
			cell.titleLabel.text = ___(@"indication_2");
			break;
		case kMagnezij:
			cell.tag = kMagnezij;
			cell.imageView.image = [UIImage imageNamed:@"icon_mg.png"];
			cell.titleLabel.text = ___(@"indication_3");
			break;
		case kSladkorna:
			cell.tag = kSladkorna;
			cell.imageView.image = [UIImage imageNamed:@"icon_sladkorna.png"];
			cell.titleLabel.text = ___(@"indication_4");
			break;
		case kSlinavka:
			cell.tag = kSlinavka;
			cell.imageView.image = [UIImage imageNamed:@"icon_slinavka.png"];
			cell.titleLabel.text = ___(@"indication_5");
			break;
		case kSecniKamni:
			cell.tag = kSecniKamni;
			cell.imageView.image = [UIImage imageNamed:@"icon_secni_kamni.png"];
			cell.titleLabel.text = ___(@"indication_6");
			break;
		case kDebelost:
			cell.tag = kDebelost;
			cell.imageView.image = [UIImage imageNamed:@"icon_debelost.png"];
			cell.titleLabel.text = ___(@"indication_7");
			break;
		case kSrceOzilje:
			cell.tag = kSrceOzilje;
			cell.imageView.image = [UIImage imageNamed:@"icon_srce_ozilje.png"];
			cell.titleLabel.text = ___(@"indication_8");
			break;
		case kStres:
			cell.tag = kStres;
			cell.imageView.image = [UIImage imageNamed:@"icon_stres.png"];
			cell.titleLabel.text = ___(@"indication_9");
			break;
		case kPocutje:
			cell.tag = kPocutje;
			cell.imageView.image = [UIImage imageNamed:@"icon_pocutje.png"];
			cell.titleLabel.text = ___(@"indication_10");
			break;
		default:
			break;
	}

	cell.active = [[SettingsManager sharedManager] activeIndication] == cell.tag;

	[cell.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:15.0f]];

	UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
	[selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f]];
	[cell setSelectedBackgroundView:selectedBackgroundView];

	return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// This shouldn't be needed, as selection isn't used, but still...
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	IndicationCell *cell = (IndicationCell *)[tableView cellForRowAtIndexPath:indexPath];

	[self performSegueWithIdentifier:@"showIndication" sender:cell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// set the title so the "back" button will be shown
	self.title = ___(@"home_screen");
	if ([segue.identifier isEqualToString:@"showIndication"]) {
		IndicationViewController *indicationController = (IndicationViewController *)[segue destinationViewController];
		indicationController.indicationType = [(UITableViewCell *)sender tag];
	}
}

@end
