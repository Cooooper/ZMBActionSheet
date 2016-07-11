//
//  ZMBActionSheet.m
//  ZMBActionSheet
//
//  Created by Han Yahui on 16/7/6.
//  Copyright © 2016年 Han Yahui. All rights reserved.
//

#import "ZMBActionSheet.h"


#define kRGBAColor(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kBGColor  kRGBAColor(160, 160, 160, 0)

#define kTitleColor  [UIColor blackColor]

#define kTitleFont   [UIFont systemFontOfSize:13]

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

//
//-(instancetype)initWithTitle:(NSString *)title
//                    delegate:(id<ZMBActionSheetDelegate>)delegate
//           cancelButtonTitle:(NSString *)cancelButtonTitle
//           otherButtonTitles:(NSString *)otherButtonTitles, ...
//{
//  self = [super init];
//
//  if (self) {
//
//    self.backgroundColor = kBGColor;
//
//    CGSize size = [UIScreen mainScreen].bounds.size;
//
//    self.frame = CGRectMake(0, 0, size.width, size.height);
//
//    _otherButtonTitles = [NSMutableArray array];
//
//    _delegate = delegate;
//    _title = title;
//    _cancelButtonTitle = cancelButtonTitle;
//
//
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                 action:@selector(hidden)];
//    [self addGestureRecognizer:tapGesture];
//    tapGesture.delegate = self;
//
//    NSString *aTitle = otherButtonTitles;
//
//    va_list titleList;
//
//    if (otherButtonTitles) {
//      va_start(titleList, otherButtonTitles);
//
//      do {
//        [_otherButtonTitles addObject:aTitle];
//        aTitle = va_arg(titleList, NSString *);
//      } while (aTitle != nil);
//
//      va_end(titleList);
//    }
//
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
//
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSheetItemIdentifer];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.scrollEnabled = NO;
//
//    [self addSubview:_tableView];
//
//  }
//
//  return self;
//}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                    otherButtonTitles:(nullable NSString *)otherButtonTitles, ...
{
  self = [super init];
  
  if (self) {
    
    self.backgroundColor = kBGColor;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    self.frame = CGRectMake(0, 0, size.width, size.height);
    
    _otherButtonTitles = [NSMutableArray array];
    
    _title = title;
    _cancelButtonTitle = cancelButtonTitle;
    
    _destructiveButtonIndex = -1;
    
    
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
  if (self.cancelButtonTitle && buttonIndex == 0) {
    return self.cancelButtonTitle;
  }
  
  if (buttonIndex - 1 > self.otherButtonTitles.count) {
    return nil;
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
  UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
  
  [nav.view addSubview:self];
  
//  nav.interactivePopGestureRecognizer.enabled = NO;
  
  CGRect frame = self.tableView.frame;
  
  frame.size.height = [self tableViewHeight];
  
  self.tableView.frame = frame;
  
  [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
    [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
      
      CGRect frame = self.tableView.frame;
      
      CGFloat y = self.frame.size.height - self.tableView.frame.size.height;
      frame.origin.y = y;
      
      self.tableView.frame = frame;
      
      self.backgroundColor = [kBGColor colorWithAlphaComponent:0.50];
      
    }];
  } completion:^(BOOL finished) {
  }];
  
}

- (void)hidden
{
  
  UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
  
//  nav.interactivePopGestureRecognizer.enabled = YES;
  
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
  
  
  if (indexPath.section == 0) {
    
    if (self.title) {
      cell.textLabel.text = self.title;
      cell.textLabel.font = kTitleFont;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.textLabel.numberOfLines = 0;
      
      cell.textLabel.textColor = self.titleColor ? self.titleColor : kTitleColor;
      
    }
    else {
      cell.textLabel.text = self.otherButtonTitles[indexPath.row];
      
      if (self.otherButtonTitleColor) {
        cell.textLabel.textColor = self.otherButtonTitleColor;
      }
      
      if (self.destructiveButtonIndex != -1 && self.destructiveButtonIndex - 1 == indexPath.row) {
        cell.textLabel.textColor = [UIColor redColor];
      }
      
      
    }
    
  }
  else if (indexPath.section == 1) {
    
    if (self.title) {
      cell.textLabel.text = self.otherButtonTitles[indexPath.row];
      if (self.otherButtonTitleColor) {
        cell.textLabel.textColor = self.otherButtonTitleColor;
      }
      
      if (self.destructiveButtonIndex != -1 && self.destructiveButtonIndex - 1 == indexPath.row) {
        cell.textLabel.textColor = [UIColor redColor];
      }
      
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
  
  [self hidden];
  
  
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
  
  
  if (index == self.destructiveButtonIndex && self.didClickedDestructiveButtonAtIndex) {
    
    self.didClickedDestructiveButtonAtIndex(self.destructiveButtonIndex);
  }
  
  
  if (index == self.cancelButtonIndex && self.didClickedCancelButtonAtIndex) {
    self.didClickedCancelButtonAtIndex(self.cancelButtonIndex);
  }
  
  
  
}


- (CGFloat)titleHeight
{
  return [self.title heightWithFont:kTitleFont constrainedToWidth:self.frame.size.width] + 15 * 2;
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






