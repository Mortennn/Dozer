// Adapted from Hidden Bar. Copyright (c) 2019 Dwarves Foundation.
// Distributed under the MIT license; see THIRD_PARTY_NOTICES.md.

import Cocoa

struct MenuBarInventoryItem {
    let bundleIdentifier: String
    let frame: CGRect
}

protocol MenuBarInventoryProviding {
    var isAuthorized: Bool { get }
    func requestAuthorization()
    func snapshot(completion: @escaping ([MenuBarInventoryItem]) -> Void)
}

final class MenuBarInventory: MenuBarInventoryProviding {
    private var requestedAuthorization = false

    var isAuthorized: Bool { AXIsProcessTrusted() }

    func requestAuthorization() {
        guard !requestedAuthorization else { return }
        requestedAuthorization = true
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
    }

    func snapshot(completion: @escaping ([MenuBarInventoryItem]) -> Void) {
        let applications = NSWorkspace.shared.runningApplications.compactMap { app -> (pid_t, String)? in
            guard app.processIdentifier != ProcessInfo.processInfo.processIdentifier,
                  app.bundleURL?.pathExtension == "app", let bundle = app.bundleIdentifier else { return nil }
            return (app.processIdentifier, bundle)
        }
        // Unresponsive apps must not block Dozer's buttons or the main thread.
        DispatchQueue.global(qos: .userInitiated).async {
            var items: [MenuBarInventoryItem] = []
            for (pid, bundle) in applications {
                let application = AXUIElementCreateApplication(pid)
                AXUIElementSetMessagingTimeout(application, 0.1)
                guard let bar = Self.attribute("AXExtrasMenuBar", of: application),
                      CFGetTypeID(bar) == AXUIElementGetTypeID(),
                      let children = Self.attribute(kAXChildrenAttribute, of: bar as! AXUIElement) as? [AXUIElement]
                else { continue }
                for child in children {
                    guard let frame = Self.frame(of: child) else { continue }
                    items.append(MenuBarInventoryItem(bundleIdentifier: bundle, frame: frame))
                }
            }
            DispatchQueue.main.async { completion(items) }
        }
    }

    private static func attribute(_ name: String, of element: AXUIElement) -> CFTypeRef? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, name as CFString, &value) == .success else { return nil }
        return value
    }

    private static func frame(of element: AXUIElement) -> CGRect? {
        guard let position = attribute(kAXPositionAttribute, of: element),
              let size = attribute(kAXSizeAttribute, of: element),
              CFGetTypeID(position) == AXValueGetTypeID(), CFGetTypeID(size) == AXValueGetTypeID()
        else { return nil }
        var origin = CGPoint.zero
        var dimensions = CGSize.zero
        guard AXValueGetValue(position as! AXValue, .cgPoint, &origin),
              AXValueGetValue(size as! AXValue, .cgSize, &dimensions),
              origin.x.isFinite, origin.y.isFinite, dimensions.width > 0, dimensions.height > 0
        else { return nil }
        return CGRect(origin: origin, size: dimensions)
    }
}
