//
//	MainViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 01/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "MainViewController.h"
#import "IndicationCell.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize headerView = _headerView;
@synthesize headerLabel = _headerLabel;

- (void)settings {
//	[self performSegueWithIdentifier:@"showSettings" sender:self];
}

- (void)calendar {
//	[self performSegueWithIdentifier:@"showCalendar" sender:self];
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

	// TODO: set the actual "active" value, this is just for testing
	cell.active = (BOOL)rand() % 2;

	switch (indexPath.item) {
		case kZaprtost:
			cell.imageView.image = [UIImage imageNamed:@"icon_zaprtost.png"];
			cell.titleLabel.text = NSLocalizedString(@"zaprtost", nil);
			break;
		case kZgaga:
			cell.imageView.image = [UIImage imageNamed:@"icon_zgaga.png"];
			cell.titleLabel.text = NSLocalizedString(@"zgaga", nil);
			break;
		case kMagnezij:
			cell.imageView.image = [UIImage imageNamed:@"icon_mg.png"];
			cell.titleLabel.text = NSLocalizedString(@"mg", nil);
			break;
		case kSladkorna:
			cell.imageView.image = [UIImage imageNamed:@"icon_sladkorna.png"];
			cell.titleLabel.text = NSLocalizedString(@"sladkorna", nil);
			break;
		case kSlinavka:
			cell.imageView.image = [UIImage imageNamed:@"icon_slinavka.png"];
			cell.titleLabel.text = NSLocalizedString(@"slinavka", nil);
			break;
		case kSecniKamni:
			cell.imageView.image = [UIImage imageNamed:@"icon_secni_kamni.png"];
			cell.titleLabel.text = NSLocalizedString(@"secni_kamni", nil);
			break;
		case kDebelost:
			cell.imageView.image = [UIImage imageNamed:@"icon_debelost.png"];
			cell.titleLabel.text = NSLocalizedString(@"debelost", nil);
			break;
		case kSrceOzilje:
			cell.imageView.image = [UIImage imageNamed:@"icon_srce_ozilje.png"];
			cell.titleLabel.text = NSLocalizedString(@"srce_ozilje", nil);
			break;
		case kStres:
			cell.imageView.image = [UIImage imageNamed:@"icon_stres.png"];
			cell.titleLabel.text = NSLocalizedString(@"stres", nil);
			break;
		case kPocutje:
			cell.imageView.image = [UIImage imageNamed:@"icon_pocutje.png"];
			cell.titleLabel.text = NSLocalizedString(@"pocutje", nil);
			break;
		default:
			break;
	}

	return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// This shouldn't be needed, as selection isn't used, but still...
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	// TODO: Add contollers
	// [self performSegueWithIdentifier:@"showIndication" sender:[NSNumber numberWithInteger:indexPath.item]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// set the title so the "back" button will be shown
	self.title = NSLocalizedString(@"seznamTitle", nil);
	if ([segue.identifier isEqualToString:@"showIndication"]) {
		// TODO: Add contollers
		//		IndicationViewController *indicationController = (IndicationViewController *)[segue destinationViewController];
		//		indicationController.indicationType = [(NSNumber *)sender integerValue];
	}
}

@end
