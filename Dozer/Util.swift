/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Cocoa

extension NSButton {
    var isChecked: Bool {
        get {
            return state == .on
        }
        set {
            state = newValue ? .on : .off
        }
    }
}

struct Icons {
    var helperstatusIcon: NSImage {
        return create(image: Assets.helperStatusItemIcon.name, 10, 10)
    }

    var removeStatusIcon: NSImage {
        return create(image: Assets.helperStatusItemIcon.name, 5, 5)
    }

    private func create(image name: String, _ width: Int, _ height: Int) -> NSImage {
        guard let image = Bundle.main.image(forResource: NSImage.Name(name)) else {
            fatalError("get image failed")
        }
        image.size = NSSize(width: width, height: height)
        return image
    }
}

/// All events starts if the auto hiding feature is turned on
public class EventMonitors {
    private var events: [EventMonitor.Global]

    init(_ event: [EventMonitor.Global] = []) {
        events = event
    }

    public func add(_ event: EventMonitor.Global) {
        events.append(event)
    }

    public func start() {
        for event in events {
            event.start()
        }
    }

    public func stop() {
        for event in events {
            event.stop()
        }
    }
}

public enum EventState: CaseIterable {
    case global, local
}

public class EventMonitor {
    public class Global {
        private var monitor: AnyObject?
        private let mask: NSEvent.EventTypeMask
        private let handler: (NSEvent) -> Void

        public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent) -> Void) {
            self.mask = mask
            self.handler = handler
        }

        deinit {
            stop()
        }

        var isActive: Bool {
            return (monitor != nil)
        }

        public func start() {
            monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject
        }

        public func stop() {
            if monitor != nil {
                NSEvent.removeMonitor(monitor!)
                monitor = nil
            }
        }
    }

    public class Local {
        private var monitor: AnyObject?
        private let mask: NSEvent.EventTypeMask
        private let handler: (NSEvent?) -> NSEvent?

        public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> NSEvent?) {
            self.mask = mask
            self.handler = handler
        }

        deinit {
            stop()
        }

        var isActive: Bool {
            if monitor != nil {
                return true
            } else {
                return false
            }
        }

        public func start() {
            monitor = NSEvent.addLocalMonitorForEvents(matching: mask, handler: handler) as AnyObject
        }

        public func stop() {
            if monitor != nil {
                NSEvent.removeMonitor(monitor!)
                monitor = nil
            }
        }
    }
}
