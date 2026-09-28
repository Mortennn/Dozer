// Adapted from Hidden Bar. Copyright (c) 2019 Dwarves Foundation.
// Distributed under the MIT license; see THIRD_PARTY_NOTICES.md.

#import "NativeVisibilityBridge.h"
#import <dlfcn.h>
#import <objc/message.h>

static NSError *VisibilityError(NSString *description) {
    return [NSError errorWithDomain:@"DozerNativeVisibility" code:1
                          userInfo:@{NSLocalizedDescriptionKey: description}];
}

BOOL DozerNativeVisibilityIsAvailable(void) {
    // Runtime loading preserves support for older macOS versions. Keep all
    // private API use here so an OS change fails without hiding anything.
    static void *framework;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        framework = dlopen("/System/Library/PrivateFrameworks/MenuBarClientCore.framework/MenuBarClientCore",
                           RTLD_NOW | RTLD_LOCAL);
    });
    Class configuration = NSClassFromString(@"MBAssessmentModeConfiguration");
    Class assertion = NSClassFromString(@"MBAssessmentModeAssertion");
    return framework && configuration && assertion
        && [configuration instancesRespondToSelector:@selector(initWithAllowedSystemItems:allowedBundleIdentifiers:)]
        && [assertion instancesRespondToSelector:@selector(activateWithConfiguration:completionHandler:)]
        && [assertion instancesRespondToSelector:@selector(invalidate)];
}

void DozerNativeVisibilityActivate(NSArray<NSString *> *allowedBundles,
                                   void (^completion)(id, NSError *)) {
    void (^finish)(id, NSError *) = ^(id assertion, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{ completion(assertion, error); });
    };
    if (!DozerNativeVisibilityIsAvailable()) {
        finish(nil, VisibilityError(@"This version of macOS does not provide the menu bar visibility service."));
        return;
    }
    id assertion = nil;
    @try {
        // Preserve Apple's items, including Control Center, Wi-Fi and the clock.
        // The API expects arrays, and ignores system item IDs absent on this Mac.
        NSMutableArray<NSNumber *> *systemItems = [NSMutableArray array];
        for (NSInteger index = 0; index < 64; index++) {
            [systemItems addObject:@(index)];
        }
        id configuration = ((id (*)(id, SEL, NSArray *, NSArray *))objc_msgSend)(
            [NSClassFromString(@"MBAssessmentModeConfiguration") alloc],
            @selector(initWithAllowedSystemItems:allowedBundleIdentifiers:), systemItems, [allowedBundles copy]);
        assertion = [[NSClassFromString(@"MBAssessmentModeAssertion") alloc] init];
        if (!configuration || !assertion) {
            finish(nil, VisibilityError(@"Could not create the menu bar visibility configuration."));
            return;
        }
        id retainedAssertion = assertion;
        ((void (*)(id, SEL, id, void (^)(NSError *)))objc_msgSend)(
            assertion, @selector(activateWithConfiguration:completionHandler:), configuration, ^(NSError *error) {
                if (error) { DozerNativeVisibilityInvalidate(retainedAssertion); }
                finish(error ? nil : retainedAssertion, error);
            });
    } @catch (NSException *exception) {
        if (assertion) { DozerNativeVisibilityInvalidate(assertion); }
        finish(nil, VisibilityError(exception.reason ?: @"The menu bar visibility service failed."));
    }
}

void DozerNativeVisibilityInvalidate(id assertion) {
    @try {
        if ([assertion respondsToSelector:@selector(invalidate)]) {
            ((void (*)(id, SEL))objc_msgSend)(assertion, @selector(invalidate));
        }
    } @catch (NSException *exception) {
        NSLog(@"Dozer could not release menu bar visibility: %@", exception.reason);
    }
}
