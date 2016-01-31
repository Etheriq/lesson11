//
//  Task3ViewController.m
//  Threads
//
//  Created by Yuriy T on 31.01.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "Task3ViewController.h"
#import "CustomImageCell.h"

@interface Task3ViewController ()

@property(strong, nonatomic) NSArray *picturesUrlArray;
@property(strong, nonatomic) NSMutableArray *pictures;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation Task3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.picturesUrlArray = @[
                           @"http://lorempixel.com/1920/1080/",
                           @"http://lorempixel.com/1920/1080/",
                           @"http://lorempixel.com/1920/1080/",
                           @"http://lorempixel.com/1920/1080/",
                           @"http://lorempixel.com/1920/1080/",
                           @"http://lorempixel.com/1920/1080/",
                           @"http://lorempixel.com/1920/1080/",
                           @"http://lorempixel.com/1920/1080/",
                           @"http://lorempixel.com/1920/1080/",
                           @"http://lorempixel.com/1920/1080/"
                           ];
    
    self.pictures = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pictures count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImage *img = [UIImage imageWithData:[[self.pictures objectAtIndex:indexPath.row] valueForKey:@"pic"]];
    cell.imageD.image = img;
    cell.labelD.text = [[self.pictures objectAtIndex:indexPath.row] valueForKey:@"txt"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}

#pragma mark - Actions
- (IBAction)load1:(UIButton *)sender {
    
    self.pictures = nil;
    self.pictures = [NSMutableArray array];
    [self.table reloadData];
    
    [self loadWithDifferentPriority:DISPATCH_QUEUE_PRIORITY_HIGH];
    
}
- (IBAction)load2:(UIButton *)sender {
    
    self.pictures = nil;
    self.pictures = [NSMutableArray array];
    [self.table reloadData];
    
    [self loadWithDifferentPriority:DISPATCH_QUEUE_PRIORITY_BACKGROUND];
    
}

-(void) loadWithDifferentPriority: (NSInteger) priority {
    
    dispatch_async(dispatch_get_global_queue(priority, 0), ^{
        double totalTimeInSec = 0;
        
        for (int i = 0; i < [self.picturesUrlArray count]; i++) {
            NSDate *start = [NSDate date];
            NSData *rowPict = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.picturesUrlArray objectAtIndex:i]]];
            NSDate *stop = [NSDate date];
            double diffLoadingTime = stop.timeIntervalSince1970 - start.timeIntervalSince1970;
            totalTimeInSec += diffLoadingTime;
            NSDictionary *obj = @{
                                  @"pic": rowPict,
                                  @"txt": [NSString stringWithFormat:@"Loaded for %.3f seconds", diffLoadingTime]
                                  };
            [self.pictures addObject:obj];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table beginUpdates];
                [self.table insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:[self.pictures count] % 2 ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight];
                [self.table endUpdates];
            });
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.title = [NSString stringWithFormat:@"Total time: %.5f seconds.", totalTimeInSec];
            [self.table reloadData];
        });
        
    });
}

- (IBAction)load3:(UIButton *)sender {
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
