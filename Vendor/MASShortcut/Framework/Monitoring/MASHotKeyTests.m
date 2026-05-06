#import "MASHotKey.h"

@interface MASHotKeyTests : XCTestCase
@end

@implementation MASHotKeyTests

- (void) testBasicFunctionality
{
    MASHotKey *hotKey = [MASHotKey registeredHotKeyWithShortcut:
        [MASShortcut shortcutWithKeyCode:kVK_ANSI_H modifierFlags:NSEventModifierFlagCommand|NSEventModifierFlagOption]];
    XCTAssertNotNil(hotKey, @"Register a simple Cmd-Alt-H hotkey.");
}

@end
