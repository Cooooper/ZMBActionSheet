//
//  ZMBActionSheet.h
//  ZMBActionSheet
//
//  Created by Han Yahui on 16/7/6.
//  Copyright © 2016年 Han Yahui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZMBActionSheetDelegate;

@interface ZMBActionSheet : UIView

/**
 *  初始化方法，请不要使用 init] 或 new]
 *
 *  @param title             如要不显示title，请使用nil,不要用@“”
 *  @param delegate          delegate优先 如果设置delegate，则self.didClickedButtonAtIndex block将不会执行
 *  @param cancelButtonTitle 如要不显示cancelButtonTitle，请使用nil,不要用@“”
 *  @param otherButtonTitles 如要不显示otherButtonTitles，请使用nil,不要用@“”
 *
 *  @return self
 */

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                     delegate:(nullable id<ZMBActionSheetDelegate>)delegate
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
            otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property(nullable,nonatomic,weak) id<ZMBActionSheetDelegate> delegate;

@property(nullable,nonatomic,copy) NSString *title;

@property(nullable,nonatomic,copy) UIColor *titleColor;
@property(nullable,nonatomic,copy) UIColor *otherButtonTitleColor;
@property(nullable,nonatomic,copy) UIColor *cancelbuttonTitleColor;

@property(nonatomic,readonly) NSInteger numberOfButtons;
@property(nonatomic,readonly) NSInteger cancelButtonIndex;

@property(nonatomic,readonly) NSInteger firstOtherButtonIndex;

- (nullable NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

- (void)show;
- (void)hidden;

@property (nullable,nonatomic,copy) void(^didClickedButtonAtIndex)(NSInteger buttonIndex);


@end


@protocol ZMBActionSheetDelegate <NSObject>

- (void)actionSheet:(nonnull ZMBActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex;

@end