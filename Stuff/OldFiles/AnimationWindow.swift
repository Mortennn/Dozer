import Cocoa

final class AnimationWindow: NSPanel {
    convenience init(frame: NSRect) {
        self.init(contentRect: frame, styleMask: .nonactivatingPanel, backing: .buffered, defer: false)
        self.isOpaque = false
        self.hasShadow = true
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.level = .init(26)
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenNone]
        self.backgroundColor = NSColor(calibratedRed: 0.13, green: 0.13, blue: 0.12, alpha: 1)
        self.ignoresMouseEvents = false
    }

    func animate() {
        self.alphaValue = 1
        self.makeKeyAndOrderFront(nil)
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = TimeInterval(0.25)
            self.animator().alphaValue = 0
        }, completionHandler: nil)
    }
}
