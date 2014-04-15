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
                
                NSRange substringRange = NSMakeRange(titleResultsRange.location - 10, 20);
//                NSLog(@"%@",item[@"menu1"]);
//                NSLog(@"module %@ found %@",moduleName,item);
//                NSLog(@"module %@ ",moduleName);
                NSString *string = [contentString substringWithRange:substringRange];
                NSLog(@"found %@",string);
                
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
    if ([searchResultArray[section][@"count"]integerValue]>0) {
        return [NSString stringWithFormat:@"%@ : %@",searchResultArray[section][@"type"],searchResultArray[section][@"count"]];
    }
    return nil;
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
    
//    NSString *contentString = [[result allValues] componentsJoinedByString:@","];
//    NSRange titleResultsRange = [contentString rangeOfString:self.keyword.text options:NSCaseInsensitiveSearch];
//    NSRange substringRange = NSMakeRange(titleResultsRange.location - 10, 20);
//    NSString *string = [contentString substringWithRange:substringRange];
//    cell.textLabel.text = string;
    cell.textLabel.text = [self getTitle:result :indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *result = searchResultArray[indexPath.section][@"detail"][indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:searchResultArray[indexPath.section][@"type"] message:[self getTitle:result :indexPath] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alert show];
}
- (NSString*)getTitle:(NSDictionary*)result :(NSIndexPath *)indexPath{
    NSString *title;
    if ([searchResultArray[indexPath.section][@"type"] isEqualToString:@"Catalog"]) {
        title = [result[@"menu1"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    if ([searchResultArray[indexPath.section][@"type"] isEqualToString:@"Special"]) {
        title = [result[@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    if ([searchResultArray[indexPath.section][@"type"] isEqualToString:@"Intro"]) {
        title = [result[@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return title;
}
- (void)highlight{
    
}
@end
