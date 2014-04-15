//
//  ViewController.h
//  FulltextSearch
//
//  Created by AlioCHIU on 2014/4/3.
//  Copyright (c) 2014年 AlioCHIU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *targetFunctionArry;
    NSMutableArray *searchResultArray;
}

@property IBOutlet UITableView *listTable;
@property IBOutlet UITextField *keyword;

- (IBAction)search:(id)sender;

@end
