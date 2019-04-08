#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "WebVuwPlugin.h"

FOUNDATION_EXPORT double web_vuwVersionNumber;
FOUNDATION_EXPORT const unsigned char web_vuwVersionString[];

