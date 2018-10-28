import Cocoa

//public class EventMonitor {
//  private var monitor: Any?
//  private let mask: NSEventMask
//  private let handler: (NSEvent?) -> ()
//  
//  public init(mask: NSEventMask, handler: @escaping (NSEvent?) -> ()) {
//    self.mask = mask
//    self.handler = handler
//  }
//  
//  deinit {
//    stop()
//  }
//  
//  public func start() {
//    self.monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
//  }
//  
//  public func stop() {
//    if self.monitor != nil {
//      NSEvent.removeMonitor(self.monitor!)
//      self.monitor = nil
//    }
//  }
//}
//
//private static let inactivityEvents: NSEventMask = [.leftMouseUp, .mouseMoved]
//
//init() {
//  self.eventMonitor = EventMonitor(mask: TrackingService.inactivityEvents) {event in
//    print("event detected: \(event)")
//    if self.isTracking() {
//      self.idleTimer = Timer.scheduledTimer(
//        timeInterval: 2 * 60,
//        target: self,
//        selector: #selector(TimeTrackingService.inactivityDetected(_:)),
//        userInfo: nil,
//        repeats: false)
//    } else {
//      self.unpauseTracking()
//    }
//  }
//}
//
//func startService() {
//  //start service will be called from a background queue
//  DispatchQueue.main.async {
//    self.eventMonitor?.start()
//  }
//}
