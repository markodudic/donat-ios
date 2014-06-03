//
//	IndicationCell.h
//	DonatMG
//
//	Created by Goran Blažič on 02/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndicationCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *activeIcon;

@property (nonatomic, assign) BOOL active;

@end
