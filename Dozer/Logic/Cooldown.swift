import Cocoa

class Cooldown {
  
  internal var startTime:TimeInterval!
  internal var cooldownPeriod:TimeInterval
  
  init(seconds:TimeInterval) {
    self.cooldownPeriod = seconds
  }
  
  func start() {
    self.startTime = NSDate().timeIntervalSince1970
  }
  
  internal func reset() {
    self.startTime = NSDate().timeIntervalSince1970
  }
  
  var isFinished:Bool {
    get {
      let now = Date().timeIntervalSince1970
      let limit = startTime + cooldownPeriod
      return (now > limit)
    }
  }
  
  
}
