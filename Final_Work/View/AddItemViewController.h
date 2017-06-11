//
//  AddItemViewController.h
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/10.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AddItemViewController : UIViewController<UITextFieldDelegate>


@property (nonatomic, weak) UIViewController* rootViewController;

@property (strong, nonatomic) IBOutlet UIView *addItemView;

@property (weak, nonatomic) IBOutlet UITextField *itemName;
@property (weak, nonatomic) IBOutlet UITextField *itemPrice;
@property (weak, nonatomic) IBOutlet UITextField *itemDate;

@property(nonatomic) Item *item;
@end
