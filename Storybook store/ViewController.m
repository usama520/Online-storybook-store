//
//  ViewController.m
//  Storybook store
//
//  Created by Usama Arshad on 28/01/2016.
//  Copyright © 2016 Usama Arshad. All rights reserved.
//

#import "ViewController.h"
#import "Parse/Parse.h"
#import "StoryListCell.h"
#import "ImageViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ViewController{
    NSMutableArray *arrayOfImages;
    NSMutableArray *arrayOfTitles;
    NSMutableArray *arrayOfCaptions;
    NSMutableArray *arrayOfPrices;
    NSMutableArray *arrayOfLargeImages;
    NSMutableArray *arrayOfUids;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.infoButton addTarget:self action:@selector(infoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [Parse setApplicationId:@"xBUhJBmkIwX0zpbrunGIHFfs7jtLtvVIZstAEK4C"
                  clientKey:@"5Dh2K3Yy5dkPL3CMDhJIJ15pQszdbfpKZqX8uba2"];
    

    PFQuery *query = [PFQuery queryWithClassName:@"books"];
    arrayOfLargeImages = [[NSMutableArray alloc]init];
    arrayOfImages = [[NSMutableArray alloc]init];
    arrayOfTitles = [[NSMutableArray alloc]init];
    arrayOfCaptions = [[NSMutableArray alloc]init];
    arrayOfPrices = [[NSMutableArray alloc]init];
    arrayOfUids = [[NSMutableArray alloc]init];
    __block int count= 0;
    __block int count1 = 0;
    __block int count2 = 0;
// saving items from web in arrays fro displaying in the tableview
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
              for (PFObject *object in objects) {
                  PFFile *image = [object valueForKey:@"image_small"];
                  PFFile *image_large =[object valueForKey:@"image_large"];
                  arrayOfImages[count] = image;
                  arrayOfLargeImages[count] = image_large;
                  
                  [arrayOfImages[count] getDataInBackgroundWithBlock:^(NSData * data, NSError * error) {
                      if(!error){
                          arrayOfImages[count1] = [UIImage imageWithData:data];
                          count1++;
                          [arrayOfLargeImages[count2] getDataInBackgroundWithBlock:^(NSData *  data, NSError *  error) {
                                  if (!error) {
                                      arrayOfLargeImages[count2] = [UIImage imageWithData:data];
                                      count2++;
                                      if (count2 == [arrayOfLargeImages count]) {
                                          [[self activityIndicator]stopAnimating];
                                          [[self tableView] reloadData];
                                      }
                                  }
                              }];

                    }
                }];
                  arrayOfTitles [count] = [object valueForKey:@"name"];
                  arrayOfCaptions [count] = [object valueForKey:@"caption"];
                  arrayOfPrices[count] = (NSNumber*)[object valueForKey:@"price"];
                  arrayOfUids[count] = [object valueForKey:@"uid"];
                  count++;
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];

}


-(NSInteger)tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayOfImages count];
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"CustomCellIdentifier";
    StoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellDesign" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    cell.thumbnail.image = [arrayOfImages objectAtIndex:indexPath.row];
    cell.caption.text = [arrayOfCaptions objectAtIndex:indexPath.row];
    cell.titleName.text =  [arrayOfTitles objectAtIndex:indexPath.row];
    
    NSNumber *price = [arrayOfPrices objectAtIndex:indexPath.row];
    NSNumber *zero = [NSNumber numberWithInteger:0];
    if (price == zero) {
        cell.priceLabel.text = [NSString stringWithFormat:@"Free"];
    }
    else{
        NSString *string = [arrayOfPrices objectAtIndex:indexPath.row];
        cell.priceLabel.text = [NSString stringWithFormat:@"$ %@",string];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"imageViewSegue" sender:self];
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"imageViewSegue"])
    {
        ImageViewController *viewController = [segue destinationViewController];
        viewController.storyLabelText = [arrayOfTitles objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        viewController.storyUid = [arrayOfUids objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        viewController.image = [arrayOfLargeImages objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}

-(void)infoButtonTapped:(id)sender{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Info" message:@"For more info visit www.usamaman.com" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alertView addAction:okButton];
    [self presentViewController:alertView animated:YES completion:nil];
}


@end
