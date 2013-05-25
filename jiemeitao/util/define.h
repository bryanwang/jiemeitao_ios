//
//  ViewController.m
//  jiemeitao
//
//  Created by tangyong on 13-5-23.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#ifndef jiemeitao_define_h
#define jiemeitao_define_h

#define APPLE_ID 0000
#define BASE_URL @""


#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 )
#define APP_SCREEN_BOUNDS   [[UIScreen mainScreen] bounds]
#define APP_SCREEN_HEIGHT   (APP_SCREEN_BOUNDS.size.height)
#define APP_SCREEN_WIDTH    (APP_SCREEN_BOUNDS.size.width)
#define APP_STATUS_FRAME    [UIApplication sharedApplication].statusBarFrame
#define APP_CONTENT_WIDTH   (APP_SCREEN_BOUNDS.size.width)
#define APP_CONTENT_HEIGHT  (APP_SCREEN_BOUNDS.size.height-APP_STATUS_FRAME.size.height)


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define CLEARCOLOR [UIColor clearColor]


#define MARGIN_HEIGHT 50.0f
#define INIT_HEIGHT 80.0f
#define CELL_WIDTH 320.0f
#define COUNT_VIEW_HEIGHT 45.0f
#define SEP_HEIGHT 12.0f
#define SECTION_HEIGHT 23.0f
#define MESSAGE_DRU 1.0f

#define DEFAULT_BG [UIImage imageNamed:@"bg-default"]

//msg
#define SHOW_INVITATION_MSG @"show invitation"


//获取View的x、y、宽度、高度
#define	GET_VIEW_X(ctlName)				((ctlName).frame.origin.x)
#define	GET_VIEW_Y(ctlName)				((ctlName).frame.origin.y)
#define	GET_VIEW_WIDTH(ctlName)			((ctlName).frame.size.width)
#define	GET_VIEW_HEIGHT(ctlName)        ((ctlName).frame.size.height)

///设置View的x、y、宽度、高度
#define	SET_VIEW_X(ctlName, newX)	\
{				\
CGRect rect = ctlName.frame;	\
rect.origin.x = (newX);			\
ctlName.frame = rect;			\
}

#define	SET_VIEW_Y(ctlName, newY)	\
{				\
CGRect rect = ctlName.frame;	\
rect.origin.y = (newY);			\
ctlName.frame = rect;			\
}

#define	SET_VIEW_WIDTH(ctlName, newWidth)	\
{				\
CGRect rect = ctlName.frame;	\
rect.size.width = (newWidth);	\
ctlName.frame = rect;			\
}

#define	SET_VIEW_HEIGHT(ctlName, newHeight)	\
{				\
CGRect rect = ctlName.frame;	\
rect.size.height = (newHeight);	\
ctlName.frame = rect;			\
}

#define	SET_VIEW_FRAME(ctlName, x, y, width, height)	\
{				\
CGRect rect = CGRectMake(x, y, width, height);  \
ctlName.frame = rect;                           \
}

//刷新界面
#define	UPDATE_VIEW(view)	[view setNeedsDisplay]

//创建VIEW
#define	UI_ALLOC_CREATE(UIctlName, x, y, width, height)	[[UIctlName alloc] initWithFrame:CGRectMake((x), (y), (width), (height))]

#define	UI_ALLOC_CREATE_EX(UIctlName, rect)             [[UIctlName alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)]


#define SYNTHESIZE_SINGLETON_FOR_HEADER(classname) \
\
+ (classname *)shared##classname;


#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \

#endif
