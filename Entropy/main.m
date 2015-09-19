//
//  main.m
//  Entropy
//
//  Created by thor on 9/18/15.
//  Copyright (c) 2015 parlequent. All rights reserved.
//

#import <Foundation/Foundation.h>

// alterkeys.c
// http://osxbook.com
//
// Complile using the following command line:
//     gcc -Wall -o alterkeys alterkeys.c -framework ApplicationServices
//
// You need superuser privileges to create the event tap, unless accessibility
// is enabled. To do so, select the "Enable access for assistive devices"
// checkbox in the Universal Access system preference pane.

#include <ApplicationServices/ApplicationServices.h>

static long keystrokes_count = 0;

// This callback will be invoked every time there is a keystroke.
//
CGEventRef
myCGEventCallback(CGEventTapProxy proxy, CGEventType type,
                  CGEventRef event, void *refcon)
{
    // Paranoid sanity check.
    if (type != kCGEventKeyDown)
        return event;
    
    keystrokes_count++;
    
    // We must return the event for it to be useful.
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
    
    // Create an event tap. We are interested in key presses.
    eventMask = ((1 << kCGEventKeyDown) | (1 << kCGEventKeyUp));
    eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0,
                                eventMask, myCGEventCallback, NULL);
    if (!eventTap) {
        fprintf(stderr, "failed to create event tap\n");
        exit(1);
    }
    
    // Create a run loop source.
    runLoopSource = CFMachPortCreateRunLoopSource(
                                                  kCFAllocatorDefault, eventTap, 0);
    
    // Add to the current run loop.
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource,
                       kCFRunLoopCommonModes);
    
    // Enable the event tap.
    CGEventTapEnable(eventTap, true);
    
    KeystrokeCounter *k = [[KeystrokeCounter alloc ] init];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0f target: [k class] selector:@selector(timerFinished:) userInfo:nil repeats: true];
    
    // Set it all running.
    CFRunLoopRun();
    
    // In a real program, one would have arranged for cleaning up.
    
    exit(0);
}
