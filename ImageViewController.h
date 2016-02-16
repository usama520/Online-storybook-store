//
//  NewViewController.h
//  Storybook store
//
//  Created by Usama Arshad on 04/02/2016.
//  Copyright © 2016 Usama Arshad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (strong, retain) IBOutlet UIImageView *largeImageView;
@property UIImage* image;
@property NSString *storyLabelText;
@property NSString *storyUid;
@end
