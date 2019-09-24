#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIControl.h>

#ifndef SIMULATOR
#import <Cephei/HBPreferences.h>
#endif

@interface SBRootFolderView : UIView

-(UIViewController *)todayViewController;

@end