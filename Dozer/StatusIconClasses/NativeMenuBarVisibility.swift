/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa

struct MenuBarVisibilityState: Equatable {
    var hideNormal = false
    var hideRemove = false
    static let expanded = MenuBarVisibilityState()
}

protocol MenuBarVisibilityAssertion: AnyObject {
    func invalidate()
}

protocol MenuBarVisibilityProviding {
    var isAvailable: Bool { get }
    func activate(allowing bundles: [String], completion: @escaping (Result<MenuBarVisibilityAssertion, Error>) -> Void)
}

private final class NativeVisibilityAssertion: MenuBarVisibilityAssertion {
    private var value: AnyObject?

    init(_ value: AnyObject) { self.value = value }

    func invalidate() {
        guard let value = value else { return }
        DozerNativeVisibilityInvalidate(value)
        self.value = nil
    }

    deinit { invalidate() }
}

struct NativeVisibilityService: MenuBarVisibilityProviding {
    var isAvailable: Bool { DozerNativeVisibilityIsAvailable() }

    func activate(allowing bundles: [String], completion: @escaping (Result<MenuBarVisibilityAssertion, Error>) -> Void) {
        DozerNativeVisibilityActivate(bundles) { assertion, error in
            if let assertion = assertion {
                completion(.success(NativeVisibilityAssertion(assertion as AnyObject)))
            } else {
                completion(.failure(error ?? NSError(domain: "DozerNativeVisibility", code: 1)))
            }
        }
    }
}

final class NativeMenuBarVisibility {
    enum Section: Int {
        case remove, normal, visible
    }

    private let inventory: MenuBarInventoryProviding
    private let service: MenuBarVisibilityProviding
    private let ownBundle: String
    private let runningBundles: () -> [String]
    private var assertion: MenuBarVisibilityAssertion?
    private var sections: [String: Section]?
    private var generation = 0
    private var isApplying = false
    private(set) var requestedState = MenuBarVisibilityState.expanded

    init(inventory: MenuBarInventoryProviding = MenuBarInventory(),
         service: MenuBarVisibilityProviding = NativeVisibilityService(),
         ownBundle: String = Bundle.main.bundleIdentifier ?? "com.mortennn.Dozer",
         runningBundles: @escaping () -> [String] = {
             NSWorkspace.shared.runningApplications.compactMap { $0.bundleIdentifier }
         }) {
        self.inventory = inventory
        self.service = service
        self.ownBundle = ownBundle
        self.runningBundles = runningBundles
    }

    // Frames passed here use Accessibility's top-left screen coordinates.
    static func classify(_ items: [MenuBarInventoryItem], normal: CGRect, remove: CGRect?) -> [String: Section] {
        var result: [String: Section] = [:]
        for item in items {
            var section = Section.visible
            // Other displays and unreadable/offscreen positions stay visible.
            if abs(item.frame.midY - normal.midY) < max(normal.height, item.frame.height),
               item.frame.midX < normal.midX {
                section = .normal
                if let remove = remove, item.frame.midX < remove.midX {
                    section = .remove
                }
            }
            // macOS hides by bundle: an app spanning sections keeps its most
            // visible placement, so an icon to the right is never lost.
            if let previous = result[item.bundleIdentifier], previous.rawValue > section.rawValue {
                continue
            }
            result[item.bundleIdentifier] = section
        }
        return result
    }

    func apply(_ state: MenuBarVisibilityState, normal: CGRect?, remove: CGRect?, completion: @escaping (Error?) -> Void) {
        generation += 1
        let request = generation
        requestedState = state
        if state == .expanded {
            restore()
            completion(nil)
            return
        }

        func fail(_ message: String) {
            restore()
            completion(NSError(domain: "DozerNativeVisibility", code: 1,
                               userInfo: [NSLocalizedDescriptionKey: message]))
        }
        guard service.isAvailable else {
            fail("Menu bar hiding is unavailable on this version of macOS. All icons have been restored.")
            return
        }
        guard inventory.isAuthorized else {
            inventory.requestAuthorization()
            fail("Allow Dozer in System Settings → Privacy & Security → Accessibility, then click a Dozer dot again.")
            return
        }
        isApplying = true
        // An unresponsive private service must not leave a half-completed hide.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self, self.generation == request, self.isApplying else { return }
            self.restore()
            completion(NSError(domain: "DozerNativeVisibility", code: 2,
                               userInfo: [NSLocalizedDescriptionKey: "The menu bar did not respond. All icons have been restored."]))
        }

        let activate: ([String: Section]) -> Void = { [weak self] sections in
            guard let self = self, self.generation == request else { return }
            self.sections = sections
            let hidden = Set(sections.compactMap { bundle, section -> String? in
                if section == .remove && state.hideRemove || section == .normal && state.hideNormal {
                    return bundle
                }
                return nil
            })
            // Preserve apps whose Accessibility data could not be read, along
            // with Dozer itself and every application in the visible section.
            let allowed = Set(self.runningBundles()).union(sections.keys).subtracting(hidden).union([self.ownBundle])
            self.service.activate(allowing: allowed.sorted()) { [weak self] result in
                guard let self = self, self.generation == request else {
                    if case .success(let stale) = result { stale.invalidate() }
                    return
                }
                self.isApplying = false
                switch result {
                case .success(let replacement):
                    let previous = self.assertion
                    self.assertion = replacement
                    previous?.invalidate()
                    completion(nil)
                case .failure(let error):
                    self.restore()
                    completion(error)
                }
            }
        }

        // Positions reported for restricted items are stale. Reuse the last
        // unrestricted snapshot until all sections have been shown again.
        if let sections = sections {
            activate(sections)
        } else if let normal = normal, normal.width > 0, normal.minX.isFinite {
            inventory.snapshot { [weak self] items in
                guard let self = self, self.generation == request else { return }
                activate(Self.classify(items, normal: normal, remove: remove))
            }
        } else {
            fail("Dozer could not read the separator's position. Show both dots in the menu bar and try again.")
        }
    }

    func restore() {
        generation += 1
        isApplying = false
        requestedState = .expanded
        assertion?.invalidate()
        assertion = nil
        sections = nil
    }

    deinit { assertion?.invalidate() }
}
