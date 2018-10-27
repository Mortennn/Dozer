import AXSwift

func checkAccessibility() -> Bool {
  return UIElement.isProcessTrusted(withPrompt: false)
}
