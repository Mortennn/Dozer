/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Foundation
import ServiceManagement
import os.log

/// Tiny wrapper around `SMAppService.mainApp` (macOS 13+). Replaces the
/// previous Carthage `LaunchAtLogin` dependency.
enum LaunchAtLogin {
    private static let logger = Logger(subsystem: "com.mortennn.Dozer", category: "LaunchAtLogin")

    static var isEnabled: Bool {
        get { SMAppService.mainApp.status == .enabled }
        set {
            do {
                if newValue {
                    guard SMAppService.mainApp.status != .enabled else { return }
                    try SMAppService.mainApp.register()
                } else {
                    guard SMAppService.mainApp.status != .notRegistered else { return }
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                logger.error("LaunchAtLogin update failed: \(error.localizedDescription, privacy: .public)")
            }
        }
    }
}
