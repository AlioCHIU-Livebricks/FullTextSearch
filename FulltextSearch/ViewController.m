//
//  ViewController.m
//  FulltextSearch
//
//  Created by AlioCHIU on 2014/4/3.
//  Copyright (c) 2014年 AlioCHIU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    targetFunctionArry = @[@"Catalog",@"Call",@"Contact",@"Coupon",@"Favorite",@"Intro",@"News",@"Profile",@"ProfilePhoto",@"Special",@"Video"];
    [self work];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)search:(id)sender{
    [self.keyword resignFirstResponder];
    [self work];
    [self.listTable reloadData];
}
- (void)work{
    NSLog(@"start");

//    NSString *searchKey = @"菜";
    NSString *searchKey = self.keyword.text;

    searchResultArray = [[NSMutableArray alloc]init];
    
    for (NSString *moduleName in targetFunctionArry) {
        NSLog(@"doing %@",moduleName);
        NSMutableArray *result = [[NSMutableArray alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Json%@",moduleName] ofType:@""];
        NSString *textData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *textDictionary = [NSJSONSerialization JSONObjectWithData: [textData dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error:nil];
        NSArray *dataArray = textDictionary[@"dintaifung"];
        
        if (!dataArray || ![dataArray isKindOfClass:[NSArray class]] || ![dataArray count]>0) {
            [searchResultArray addObject:@{@"count":@"0",@"detail":@"",@"type":moduleName}];
            continue;
        }
        NSInteger count = 0;
        for (NSDictionary *item in dataArray) {
            NSString *contentString = [[item allValues] componentsJoinedByString:@","];
            NSRange titleResultsRange = [contentString rangeOfString:searchKey options:NSCaseInsensitiveSearch];
            //NSLog(@"sTemp = %@, searchText = %@",sTemp,searchText);
            
            if (titleResultsRange.length > 0){
//                NSLog(@"%@",item[@"menu1"]);
//                NSLog(@"module %@ found %@",moduleName,item);
                NSLog(@"module %@ ",moduleName);
                [result addObject:item];
                count++;
            }
        }
        [searchResultArray addObject:@{@"count":[NSString stringWithFormat:@"%d",count],@"detail":result,@"type":moduleName}];
    }
    
    
    NSLog(@"end");
    
    
//    NSLog(@"%@",searchResultArray);
//    for (NSDictionary *result in searchResultArray) {
//        NSLog(@"%@",result[@"count"]);
//    }
    [self.listTable reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [searchResultArray count];
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%@ : %@",searchResultArray[section][@"type"],searchResultArray[section][@"count"]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [searchResultArray[section][@"count"] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    NSDictionary *result = searchResultArray[indexPath.section][@"detail"][indexPath.row];
    
    NSString *title;
    if ([searchResultArray[indexPath.section][@"type"] isEqualToString:@"Catalog"]) {
        cell.textLabel.text = [result[@"menu1"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    if ([searchResultArray[indexPath.section][@"type"] isEqualToString:@"Special"]) {
        title = [NSString stringWithFormat:@"%@",result[@"description"]];
    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self getDesc:result]];
    return cell;
}
- (NSString*)getDesc:(NSDictionary*)result{
    NSString *title;
    if ([result[@"type"] isEqualToString:@"Catalog"]) {
        title = [[NSString stringWithFormat:@"%@",result[@"menu1"]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    if ([result[@"type"] isEqualToString:@"Special"]) {
        title = [NSString stringWithFormat:@"%@",result[@"description"]];
    }
    
    return title;
}
@end
