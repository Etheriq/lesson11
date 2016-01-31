//
//  Task2ViewController.m
//  Threads
//
//  Created by Yuriy T on 31.01.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "Task2ViewController.h"
#import "FibonachiManager.h"

@interface Task2ViewController ()

@property(strong, nonatomic) NSMutableArray *fibArray;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation Task2ViewController

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

#pragma mark - Actions

- (IBAction)task2Fire:(UIBarButtonItem *)sender {
    
    self.fibArray = nil;
    self.fibArray = [NSMutableArray array];
    [self.table reloadData];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        
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
                
                [self performSelectorOnMainThread:@selector(insertRowIntoTable) withObject:nil waitUntilDone:NO];
                
                step = 0;
            }
            step++;
            [NSThread sleepForTimeInterval:0.01f];
        }
        
    }];
    
    [queue addOperation:blockOperation];
}

-(void) insertRowIntoTable {
    NSInteger index =  [self.fibArray count] - 1;
    
    [self.table beginUpdates];
    [self.table insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:[self.fibArray count] % 2 ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight];
    [self.table endUpdates];
}

@end
