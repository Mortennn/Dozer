// Adapted from Hidden Bar. Copyright (c) 2019 Dwarves Foundation.
// Distributed under the MIT license; see THIRD_PARTY_NOTICES.md.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
BOOL DozerNativeVisibilityIsAvailable(void);
void DozerNativeVisibilityActivate(NSArray<NSString *> *allowedBundles,
                                   void (^completion)(id _Nullable assertion, NSError * _Nullable error));
void DozerNativeVisibilityInvalidate(id assertion);
NS_ASSUME_NONNULL_END
