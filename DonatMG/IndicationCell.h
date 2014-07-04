//
//	IndicationCell.h
//	DonatMG
//
//	Created by Goran Blažič on 29/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndicationCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *activeIcon;

@property (nonatomic, assign) BOOL active;

@end
