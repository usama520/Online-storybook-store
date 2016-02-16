//
//  NewViewController.m
//  Storybook store
//
//  Created by Usama Arshad on 04/02/2016.
//  Copyright © 2016 Usama Arshad. All rights reserved.
//

#import "ImageViewController.h"
#import "Stories.h"

@interface ImageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *storyLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.largeImageView.image = self.image;
    [self.arrowButton setImage:[UIImage imageNamed:@"downArrow.png"] forState:UIControlStateNormal];
    self.storyLabel.text = self.storyLabelText;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"StoriesSegue"])
    {
        Stories *stories = [segue destinationViewController];
        stories.storyId = self.storyUid;
        stories.storyName = self.storyLabelText;
    }
}


@end
