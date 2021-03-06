//
//  IncomesListViewController.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/8.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "IncomesListViewController.h"

#import "CostCell.h"
#import "RootViewController.h"
#import "AddItemViewController.h"

#import "ItemManager.h"
#import "Item.h"

#import <MagicalRecord/MagicalRecord.h>

@interface IncomesListViewController ()

@end

@implementation IncomesListViewController {
    NSArray* _items;
    NSMutableArray* _income;
    
    UIDatePicker *datePicker;
    NSDateFormatter *formatter;
}


#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.incomeListView.emptyDataSetSource = self;
    self.incomeListView.emptyDataSetDelegate = self;
    self.incomeListView.tableFooterView = [UIView new];
    
    _income = [NSMutableArray new];
    _items = @[_income];
    
    
    
    UINib* nib = [UINib nibWithNibName:@"CostCell" bundle:nil];
    [self.incomeListView registerNib:nib forCellReuseIdentifier:CostCellIdentifier];
    //=================================================================//
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    datePicker = [[UIDatePicker alloc] init];
    
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    
    datePicker.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [datePicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    //space
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //date
    UIToolbar *dateToolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 44)];
    [dateToolBar setTintColor:[UIColor whiteColor]];
    dateToolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *dateDoneBtn=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed)];
    
    
    [dateToolBar setItems:[NSArray arrayWithObjects:space,dateDoneBtn, nil]];
    [_dateSelectTextField setInputView:datePicker];
    [_dateSelectTextField setInputAccessoryView:dateToolBar];
    [[_dateSelectTextField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    
    //======================================================================//
    UISwipeGestureRecognizer *swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
    UISwipeGestureRecognizer *swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
    swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeR];
    [self.view addGestureRecognizer:swipeL];
    //======================================================================//
    
    
    
    
    [self chooseDate:datePicker];
    [self updateItems];
    [self calculateBudget];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemsSynchronized) name:ItemsSynchronizedNotificationName object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self itemsSynchronized];
    [self.rootViewController setTitle:@"收入"];
    [self.incomeListView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *index =  [_incomeListView indexPathForCell:(CostCell*)[previewingContext sourceView]];
    
    AddItemViewController *addItemViewController = [[AddItemViewController alloc] init];
    addItemViewController.item = [self itemAtIndexPath:index];
    return addItemViewController;

}
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    //    [self showViewController:viewControllerToCommit sender:self];
    [_rootViewController.navigationController pushViewController:viewControllerToCommit animated:NO];
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"picture"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"尚未新增項目";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"點擊下方➕按鈕，進行項目新增";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    return 100;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView* myView = [[UIView alloc] init];
//    myView.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:0.7];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 22)];
//    titleLabel.textColor=[UIColor whiteColor];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.text=[self.keys objectAtIndex:section];
//    [myView addSubview:titleLabel];
//    [titleLabel release];
//    return myView;
//
//}
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
    return YES;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    AddItemViewController *viewController = [[AddItemViewController alloc] initWithNibName:@"AddItemView" bundle:nil];
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    
    
    viewController.item = [Item MR_createEntity];
    viewController.item = [self itemAtIndexPath:indexPath];
    [_rootViewController.navigationController pushViewController:viewController animated:NO];
}
- (NSArray<UITableViewRowAction*> *)tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath*)indexPath {
    NSString* title = @"delete";
    UITableViewRowAction* action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title handler:^(UITableViewRowAction* _Nonnull action, NSIndexPath* _Nonnull path) {
        Item *deleteItem = [self itemAtIndexPath:indexPath];
        [deleteItem MR_deleteEntity];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [[NSNotificationCenter defaultCenter] postNotificationName:ItemsSynchronizedNotificationName object:nil];
    }];
    return @[ action ];
}

-(void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass: [UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView* castView = (UITableViewHeaderFooterView*) view;
        UIView* content = castView.contentView;
        content.backgroundColor = [UIColor colorWithRed:0.584 green:1 blue:0.816 alpha:1];
//        switch (section) {
//            case 2:
//                content.backgroundColor  = [UIColor colorWithRed:0.827 green:0.639 blue:1 alpha:1];
//                break;
//            case 1:
//                content.backgroundColor  = [UIColor colorWithRed:0.6 green:0.8 blue:1 alpha:1];
//                break;
//            case 0:
//                content.backgroundColor  = [UIColor colorWithRed:1 green:0.761 blue:0.878 alpha:1];
//                break;
//            case 3:
//                content.backgroundColor  = [UIColor colorWithRed:1 green:1 blue:0.439 alpha:1];
//                break;
//            case 4:
//                content.backgroundColor  = [UIColor colorWithRed:0.584 green:1 blue:0.816 alpha:1];
//                break;
//            default:
//                break;
//        }
    }
    
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if (_income.count == 0) return nil;
            else return @"收入";
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return [_items count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_items objectAtIndex:section] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    Item* poster = [self itemAtIndexPath:indexPath];
    CostCell* cell = [tableView dequeueReusableCellWithIdentifier:CostCellIdentifier forIndexPath:indexPath];
    [self registerForPreviewingWithDelegate:self sourceView:cell];
    [cell setItem:poster];
    
    return cell;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
    if (datePicker.superview) {
        [datePicker removeFromSuperview];
    } else {
        [self chooseDate:datePicker];
    }
    return YES;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_dateSelectTextField resignFirstResponder];
}


#pragma mark - Private Methods

- (void)itemsSynchronized {
    [self updateItems];
    [self calculateBudget];
}
- (void)calculateBudget
{
    NSUInteger budgetValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"budget"];
    NSUInteger startValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"startdate"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    [components setDay:startValue];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    [components setYear:0];
    [components setMonth:1];
    [components setDay:-1];
    NSDate *endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
    
    [components setMonth:0];
    NSInteger dayTimeInterval = [endDate timeIntervalSinceDate:startDate]/86400;
    
    NSArray *items;
    NSUInteger sum = 0;
    
    for (int i = 0; i <= dayTimeInterval; i++) {
        [components setDay:i];
        NSDate *selectDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
        items = [Item MR_findByAttribute:@"date" withValue:selectDate];
        for (Item* item in items) {
            if ([item.category isEqualToString:@"收入"]) continue;
            sum += [item.price integerValue];
        }
        
    }
    
    self.budgetBarLabel.text = [NSString stringWithFormat:@"預算： %lu / %lu", (unsigned long)sum, (unsigned long)budgetValue];
    if (sum > budgetValue) {
        [self.budgetBarLabel setTextColor:[UIColor redColor]];
    } else if (sum > budgetValue/2) {
        [self.budgetBarLabel setTextColor:[UIColor orangeColor]];
    } else {
        [self.budgetBarLabel setTextColor:[UIColor greenColor]];
    }
}
-(void)swipeRecognized:(UISwipeGestureRecognizer*)swipeGesture
{
    self.currentSelectDate = [formatter dateFromString:_dateSelectTextField.text];
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.currentSelectDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:self.currentSelectDate];
        [UIView transitionWithView:self.incomeListView
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^(void) {
                            [self.incomeListView reloadData];
                        } completion:NULL];
        
    } else if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight) {
        self.currentSelectDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:self.currentSelectDate];
        [UIView transitionWithView:self.incomeListView
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^(void) {
                            [self.incomeListView reloadData];
                        } completion:NULL];
        
    }
    _dateSelectTextField.text = [formatter stringFromDate:self.currentSelectDate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ItemsSynchronizedNotificationName object:nil];
    
}
- (void)chooseDate:(UIDatePicker *)datePick
{
    NSDate *selectedDate = datePick.date;
    _dateSelectTextField.text = [formatter stringFromDate:selectedDate];
    self.currentSelectDate = [formatter dateFromString:_dateSelectTextField.text];
    
}
- (void)doneButtonPressed
{
    if (![_dateSelectTextField.text isEqualToString:[formatter stringFromDate:[NSDate date]]])
        [[NSNotificationCenter defaultCenter] postNotificationName:ItemsSynchronizedNotificationName object:nil];
    [_dateSelectTextField resignFirstResponder];
}

- (void)updateItems {
    [_income removeAllObjects];
    
    NSArray *items = [Item MR_findByAttribute:@"date" withValue:self.currentSelectDate];
    for (Item* item in items) {
        if (!item.name || !item.price) continue;
        if ([item.category isEqualToString:@"收入"]) {
            [_income addObject:item];
        }
    }
    [self.incomeListView reloadData];
    
}

- (Item*)itemAtIndexPath:(NSIndexPath*)indexPath {
    return [[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}
@end
