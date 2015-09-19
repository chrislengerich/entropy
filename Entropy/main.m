#import <Foundation/Foundation.h>

#include <ApplicationServices/ApplicationServices.h>

// Forked from http://osxbook.com/book/bonus/chapter2/alterkeys/.

static long keystrokes_count = 0;

CGEventRef
myCGEventCallback(CGEventTapProxy proxy, CGEventType type,
                  CGEventRef event, void *refcon)
{
    if (type != kCGEventKeyDown)
        return event;
    
    keystrokes_count++;
    return event;
}


@interface KeystrokeCounter : NSObject

+ (void) timerFinished :(NSTimer *)timer ;

@end

@implementation KeystrokeCounter

+ (void) timerFinished :(NSTimer *)timer {
    NSLog(@"%ld", keystrokes_count);
    keystrokes_count = 0;
}

@end

int
main(void)
{
    CFMachPortRef      eventTap;
    CGEventMask        eventMask;
    CFRunLoopSourceRef runLoopSource;
    
    eventMask = ((1 << kCGEventKeyDown) | (1 << kCGEventKeyUp));
    eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0,
                                eventMask, myCGEventCallback, NULL);
    if (!eventTap) {
        fprintf(stderr, "failed to create event tap\n");
        exit(1);
    }
    
    runLoopSource = CFMachPortCreateRunLoopSource(
                                                  kCFAllocatorDefault, eventTap, 0);
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource,
                       kCFRunLoopCommonModes);
    
    CGEventTapEnable(eventTap, true);
    
    KeystrokeCounter *k = [[KeystrokeCounter alloc ] init];
    
    // Default timer is 60s
    [NSTimer scheduledTimerWithTimeInterval:60.0f target: [k class] selector:@selector(timerFinished:) userInfo:nil repeats: true];
    
    CFRunLoopRun();
    
    exit(0);
}
