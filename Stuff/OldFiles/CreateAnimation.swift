private func createAnimation() {
    let normalStatusIconRightX = Int(DozerStatusIconController.shared.get(dozerIcon: .normalRight).xPositionOnScreen)
    let leftStatusIconPosition = getLeftStatusIcon()
    let frame = NSRect(
        x: leftStatusIconPosition,
        y: Int(NSScreen.main!.frame.height - 22),
        width: normalStatusIconRightX - leftStatusIconPosition,
        height: 22)
    let animationWindow = AnimationWindow(frame: frame)
    animationWindow.orderFront(nil)
    animationWindow.animate()
}
