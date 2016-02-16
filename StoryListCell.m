//
//  CustomTableCell.m
//  Storybook store
//
//  Created by Usama Arshad on 04/02/2016.
//  Copyright © 2016 Usama Arshad. All rights reserved.
//

#import "StoryListCell.h"

@implementation StoryListCell
@synthesize thumbnail = _thumbnail;
@synthesize titleName = _titleName;
@synthesize caption = _caption;
@synthesize priceLabel = _priceLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
