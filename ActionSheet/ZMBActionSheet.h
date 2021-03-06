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

///**
// *  初始化方法，请不要使用 init] 或 new]
// *
// *  @param title             如要不显示title，请使用nil,不要用@“”
// *  @param delegate          delegate优先 如果设置delegate，则self.didClickedButtonAtIndex block将不会执行
// *  @param cancelButtonTitle 如要不显示cancelButtonTitle，请使用nil,不要用@“”
// *  @param otherButtonTitles 如要不显示otherButtonTitles，请使用nil,不要用@“”
// *
// *  @return self
// */
//
//- (nonnull instancetype)initWithTitle:(nullable NSString *)title
//                             delegate:(nullable id<ZMBActionSheetDelegate>)delegate
//                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
//                    otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


/**
 *  初始化方法，请不要使用 init] 或 new]
 *
 *  @param title             如要不显示title，请使用nil,不要用@“”
 *  @param cancelButtonTitle 如要不显示cancelButtonTitle，请使用nil,不要用@“”
 *  @param otherButtonTitles 如要不显示otherButtonTitles，请使用nil,不要用@“”
 *
 *  @return self
 */

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                    otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


@property(nullable,nonatomic,weak) id<ZMBActionSheetDelegate> delegate;

@property(nullable,nonatomic,copy) NSString *title;

@property(nullable,nonatomic,copy) UIColor *titleColor; //default kLightTextColor.
@property(nullable,nonatomic,copy) UIColor *otherButtonTitleColor;
@property(nullable,nonatomic,copy) UIColor *cancelbuttonTitleColor;

@property(nonatomic,readonly) NSInteger numberOfButtons; // buttons contain otherButtons and cancelButton.
@property(nonatomic,readonly) NSInteger cancelButtonIndex; // if cancelButton use, cancelButtonIndex is 0

@property(nonatomic,readonly) NSInteger firstOtherButtonIndex; // if otherButton exist, firstOtherButtonIndex is 1

@property(nonatomic) NSInteger destructiveButtonIndex;        // sets destructive (red) button. -1 means none set. default is -1. ignored if only one button



- (nullable NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

- (void)show;
- (void)hidden;

@property (nullable,nonatomic,copy) void(^didClickedButtonAtIndex)(NSInteger buttonIndex);
@property (nullable,nonatomic,copy) void(^didClickedDestructiveButtonAtIndex)(NSInteger destructiveButtonIndex);
@property (nullable,nonatomic,copy) void(^didClickedCancelButtonAtIndex)(NSInteger cancelButtonIndex);


@end


@protocol ZMBActionSheetDelegate <NSObject>

- (void)actionSheet:(nonnull ZMBActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex;

@end