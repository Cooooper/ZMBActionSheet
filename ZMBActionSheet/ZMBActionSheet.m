//
//  ZMBActionSheet.m
//  ZMBActionSheet
//
//  Created by Han Yahui on 16/7/6.
//  Copyright © 2016年 Han Yahui. All rights reserved.
//

#import "ZMBActionSheet.h"

#import "Masonry.h"

#define kRGBAColor(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kBGColor  kRGBAColor(160, 160, 160, 0)


@interface NSString (Addition)

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

@end

@implementation NSString (Addition)


- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
  
  NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
  CGRect bounds = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:options
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil];
  return bounds.size.height;
}

@end




static NSString *kSheetItemIdentifer = @"SheetItemIdentifer";

@interface ZMBActionSheet ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>


@property (nonatomic,readwrite) UITableView *tableView;

@property (nonatomic,readwrite) NSMutableArray <NSString *> *otherButtonTitles;

@property (nonatomic,copy) NSString *cancelButtonTitle;


@end

@implementation ZMBActionSheet


-(instancetype)initWithTitle:(NSString *)title
                    delegate:(id<ZMBActionSheetDelegate>)delegate
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ...
{
  self = [super init];
  
  if (self) {
    
    self.backgroundColor = kBGColor;
    
    CGSize size = [UIScreen mainScreen].bounds.size;

    self.frame = CGRectMake(0, 0, size.width, size.height);
    
    _otherButtonTitles = [NSMutableArray array];
    
    _delegate = delegate;
    _title = title;
    _cancelButtonTitle = cancelButtonTitle;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(hidden)];
    [self addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    
    NSString *aTitle = otherButtonTitles;
    
    va_list titleList;
    
    if (otherButtonTitles) {
      va_start(titleList, otherButtonTitles);
      
      do {
        [_otherButtonTitles addObject:aTitle];
        aTitle = va_arg(titleList, NSString *);
      } while (aTitle != nil);
      
      va_end(titleList);
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSheetItemIdentifer];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    
    [self addSubview:_tableView];
  
  }
  
  return self;
}



- (nullable NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0) {
    return self.cancelButtonTitle;
  }
  return self.otherButtonTitles[buttonIndex - 1];
  
}



-(NSInteger)numberOfButtons
{
  NSInteger number = self.otherButtonTitles.count;
  
  return self.cancelButtonTitle ? ++number : number;
}


- (void)show
{
  [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
  
  CGRect frame = self.tableView.frame;
  
  frame.size.height = [self tableViewHeight];
  
  self.tableView.frame = frame;
  
  [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
    [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
      
      CGRect frame = self.tableView.frame;
      
      CGFloat y = self.frame.size.height - self.tableView.frame.size.height;
      frame.origin.y = y;
      
      self.tableView.frame = frame;
      
      self.backgroundColor = [kBGColor colorWithAlphaComponent:0.40];

    }];
  } completion:^(BOOL finished) {
  }];
  
}

- (void)hidden
{
  [UIView animateWithDuration:0.3 animations:^{
    
    CGRect frame = self.tableView.frame;
    
    frame.origin.y = self.frame.size.height;
    
    self.tableView.frame = frame;
    
    self.alpha = 0;
    
  } completion:^(BOOL finished) {
    if (finished) {
      [self removeFromSuperview];
    }
  }];
}


-(NSInteger)firstOtherButtonIndex
{
  return 1;
}

- (NSInteger)cancelButtonIndex
{
  return 0;
}

#pragma mark -
#pragma mark - gestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  if([touch.view isKindOfClass:[self class]]){
    return YES;
  }
  return NO;
}


#pragma mark -
#pragma mark - tableview dataSource & delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
  NSInteger number = 1;
  
  number = self.title ? ++number : number;

  number = self.cancelButtonTitle ? ++number : number;
  
  return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == 0) {
    
    if (self.title) {
      return 1;
    }
    else {
      return self.otherButtonTitles.count;
    }
    
  }
  else if (section == 1) {
  
    if (self.title) {
      return self.otherButtonTitles.count;
    }
    else {
      return 1;
    }
    
  }
  else if (section == 2) {
    
    if (self.cancelButtonTitle) {
      return 1;
    }
    
  }

  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSheetItemIdentifer
                                                          forIndexPath:indexPath];
  
  cell.textLabel.textAlignment = NSTextAlignmentCenter;
  cell.textLabel.adjustsFontSizeToFitWidth = YES;
  cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
  
  if (self.otherButtonTitleColor) {
    cell.textLabel.textColor = self.otherButtonTitleColor;
  }

  
  if (indexPath.section == 0) {
    
    if (self.title) {
      cell.textLabel.text = self.title;
      cell.textLabel.font = [UIFont systemFontOfSize:14];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.textLabel.numberOfLines = 0;
      
      if (self.titleColor) {
        cell.textLabel.textColor = self.titleColor;
      }
      
    }
    else {
      cell.textLabel.text = self.otherButtonTitles[indexPath.row];
    }
    
  }
  else if (indexPath.section == 1) {
    
    if (self.title) {
      cell.textLabel.text = self.otherButtonTitles[indexPath.row];
    }
    else {
      cell.textLabel.text = self.cancelButtonTitle;
      
      if (self.cancelbuttonTitleColor) {
        cell.textLabel.textColor = self.cancelbuttonTitleColor;
      }
      
    }
    
  }
  else if (indexPath.section == 2) {
    
    if (self.cancelButtonTitle) {
      cell.textLabel.text = self.cancelButtonTitle;
    }
    if (self.cancelbuttonTitleColor) {
      cell.textLabel.textColor = self.cancelbuttonTitleColor;
    }
    
  }

  
  return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
  if (section == [tableView numberOfSections] - 1 && self.cancelButtonTitle) {
    return 10;
  }
  
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.title && indexPath.section == 0) {
    return [self titleHeight];
  }
  return 50;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  if (self.title && indexPath.section == 0) {
    return;
  }
  
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  NSInteger index = 0;
  if ((self.title && indexPath.section == 1) || (!self.title && indexPath.section == 0)) {
    
    index = indexPath.row + 1;
  }
  
  
  if ([self.delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
    
    [self.delegate actionSheet:self didClickedButtonAtIndex:index];
  }
  else if (self.didClickedButtonAtIndex) {
   
    self.didClickedButtonAtIndex(index);
 
  }
  
  [self hidden];

}


- (CGFloat)titleHeight
{
  return [self.title heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:self.frame.size.width] + 15 * 2;
}

- (CGFloat)tableViewHeight
{
  CGFloat height =  self.otherButtonTitles.count * 50;
  
  if (self.title) {
    height += [self titleHeight];
  }
  
  if (self.cancelButtonTitle) {
    height += 60;
  }
  return height;
}

@end






