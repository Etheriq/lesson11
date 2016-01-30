//
//  Task1ViewController.m
//  Threads
//
//  Created by Yuriy T on 30.01.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "Task1ViewController.h"
#import "FibonachiManager.h"

@interface Task1ViewController ()

@property(strong, nonatomic) NSMutableArray *fibArray;

@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation Task1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fibArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fibArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.fibArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Action

- (IBAction)startFibCalculation:(UIBarButtonItem *)sender {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        int  step = 0;
        
        for (int i = 0; i <= 100; i++) {
            
            NSDecimalNumber *current = [FibonachiManager calculateFib:i];
            NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
            [numberFormat setMaximumFractionDigits:5];
            [numberFormat setMinimumIntegerDigits:1];
            
            NSArray *tmp = [[numberFormat stringFromNumber:current] componentsSeparatedByString:@"."];
            NSString *result = [NSString stringWithFormat:@"Fib %i = %@", i, [tmp objectAtIndex:0]];
//            NSLog(@"%@", result);
            
            if (step == 10) {
                [self.fibArray addObject: result];
                
                NSInteger index =  [self.fibArray count] - 1;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.table beginUpdates];
                    [self.table insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:[self.fibArray count] % 2 ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight];
                    
                    [self.table endUpdates];
                });
                step = 0;
            }
            step++;
            [NSThread sleepForTimeInterval:0.05f];
        }
    });
}

@end
