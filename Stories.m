//
//  Stories.m
//  Storybook store
//
//  Created by Usama Arshad on 04/02/2016.
//  Copyright © 2016 Usama Arshad. All rights reserved.
//

#import "Stories.h"
#import "CustomTableViewCell.h"
#import "Parse/Parse.h"
#import "ImageViewController.h"
#include "ChatLabel.h"

@interface Stories ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *arrayOfStories;
    NSMutableArray *senders;
    NSMutableArray *sequence;
    __weak IBOutlet UIBarButtonItem *backButton;
    int senderIndex;
    __weak IBOutlet UITableView *tblView;
}
@end

@implementation Stories

- (void)viewDidLoad {
    [super viewDidLoad];
    [tblView setDelegate:self];
    [tblView setDataSource:self];
    [self viewSetup];
    PFQuery *query = [PFQuery queryWithClassName:@"texts"];
    arrayOfStories = [[NSMutableArray alloc] init];
    senders = [[NSMutableArray alloc]init];
    sequence = [[NSMutableArray alloc]init];
    __block int count = 0;
    [query whereKey:@"uid" equalTo:self.storyId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        if (!error) {
            for (PFObject *object  in objects) {
                arrayOfStories[count] = [object valueForKey:@"text"];
                senders[count] = [object valueForKey:@"sender"];
                sequence[count] = (NSNumber*)[object valueForKey:@"seq"];
                count++;
            }
            [tblView reloadData];
        }
    }];
}



-(void)viewSetup{
    tblView.estimatedRowHeight = 45.0f;
    tblView.rowHeight = UITableViewAutomaticDimension;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([arrayOfStories count]>=1) {
        NSMutableArray *tempStories = [NSMutableArray new];
        NSMutableArray *tempSenders = [NSMutableArray new];
        for (int i = 0; i<[arrayOfStories count]; i++) {
            tempStories[i] = arrayOfStories[i];
            tempSenders[i] = senders[i];
        }
        for (int i = 0; i<[arrayOfStories count]; i++) {
            int k = i+1;
            NSNumber *comparingNumber = sequence[i];
            if (k==[comparingNumber intValue]) {
                continue;
            }
            else{
                NSNumber *indexNumber = sequence[i];
                arrayOfStories[[indexNumber intValue]-1] = [tempStories objectAtIndex:k-1];
                senders[[indexNumber intValue]-1] = [tempSenders objectAtIndex:k-1];
                arrayOfStories[k-1] = tempStories[[indexNumber intValue]-1];
                senders[k-1] = tempSenders[[indexNumber intValue]-1];
            }
        }
    }
    return [arrayOfStories count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    senderIndex = 0;
    static NSString *leftCellIdentifier = @"LeftChatCell";
    static NSString *rightCellIdentifier = @"RightChatCell";
    if (senders[indexPath.row] == senders[senderIndex]) {
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCellIdentifier];
        ChatLabel *messageLabel = (ChatLabel *)[cell viewWithTag:101];
        
        messageLabel.textInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    
        messageLabel.layer.cornerRadius = 10.f;
        messageLabel.layer.masksToBounds = YES;
        tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [messageLabel setText:arrayOfStories[indexPath.row]];
        return cell;
    }
    else{
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightCellIdentifier];
        ChatLabel *messageLabel = (ChatLabel*)[cell viewWithTag:101];
        messageLabel.layer.cornerRadius = 10.f;
        messageLabel.textInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        messageLabel.layer.masksToBounds = YES;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [messageLabel setText:arrayOfStories[indexPath.row]];
        return cell;
    }

}






@end
