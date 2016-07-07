//
//  ViewController.m
//  ZMBActionSheet
//
//  Created by Han Yahui on 16/7/6.
//  Copyright © 2016年 Han Yahui. All rights reserved.
//

#import "ViewController.h"

#import "ZMBActionSheet.h"

@interface ViewController ()<ZMBActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 40)];
  [self.view addSubview:btn];
  
  [btn setTitle:@"打开（有Title）" forState:UIControlStateNormal];
  [btn setBackgroundColor:[UIColor orangeColor]];
  [btn addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
  
  UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 40)];
  [self.view addSubview:btn1];
  
  [btn1 setTitle:@"打开（无Title）" forState:UIControlStateNormal];
  [btn1 setBackgroundColor:[UIColor orangeColor]];
  [btn1 addTarget:self action:@selector(open1) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)open
{
  ZMBActionSheet *sheet = [[ZMBActionSheet alloc] initWithTitle:@"我是不是你最心爱的人？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"嗯哼",@"让我考虑一分钟", nil];

  
  [sheet show];
}

- (void)actionSheet:(nonnull ZMBActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex
{
  
  if (buttonIndex == actionSheet.cancelButtonIndex) {
    NSLog(@"cancelButtonIndex");
  }
  if (buttonIndex == actionSheet.firstOtherButtonIndex) {
    NSLog(@"firstOtherButtonIndex");
    
  }
  
}

- (void)open1
{
  ZMBActionSheet *sheet = [[ZMBActionSheet alloc] initWithTitle:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"小视频",@"拍照",@"从手机相册选择", nil];
  
  
  sheet.didClickedButtonAtIndex  = ^(NSInteger buttonIndex) {
    
    if (buttonIndex == sheet.cancelButtonIndex) {
      NSLog(@"cancelButtonIndex");
    }
    if (buttonIndex == sheet.firstOtherButtonIndex) {
      NSLog(@"firstOtherButtonIndex");
      
    }
    
  };
  
  [sheet show];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
