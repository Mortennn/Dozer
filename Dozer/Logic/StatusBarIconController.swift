import Cocoa

struct Icons {
  
  var statusBarIcon:NSImage {
    get {
      return create(image: "StatusBarIcon", 10, 10)
    }
  }
  
  internal func create(image name:String, _ width:Int, _ height:Int) -> NSImage {
    guard let image = Bundle.main.image(forResource: NSImage.Name(name)) else {
      fatalError("get image failed")
    }
    image.size = NSSize(width: width, height: height)
    return image
  }
}
