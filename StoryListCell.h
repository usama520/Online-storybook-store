//
//  CustomTableCell.h
//  Storybook store
//
//  Created by Usama Arshad on 04/02/2016.
//  Copyright © 2016 Usama Arshad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryListCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *thumbnail;
@property (nonatomic, weak) IBOutlet UILabel *titleName;
@property (nonatomic, weak) IBOutlet UILabel *caption;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@end
