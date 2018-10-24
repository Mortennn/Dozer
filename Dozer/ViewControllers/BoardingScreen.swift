//
//  BoardingScreen.swift
//  Dozer
//
//  Created by Morten Nautrup Nielsen on 02/10/2018.
//

import Cocoa
import AVKit

class BoardingScreen: NSViewController {

  @IBOutlet var ContinueButton: NSButton!
  @IBOutlet var moveDozer: AVPlayerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
    
    // button config
    ContinueButton.focusRingType = .none

    let videoURL = Bundle.main.url(forResource: "Demo", withExtension: "mp4")!
    let player = AVPlayer(url: videoURL)
    moveDozer.player = player
    moveDozer.controlsStyle = .none
    moveDozer.player?.actionAtItemEnd = .none
    
    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: moveDozer.player?.currentItem, queue: .main) { _ in
      self.moveDozer.player?.seek(to: CMTime.zero)
      self.moveDozer.player?.play()
    }
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    moveDozer.player?.play()
  }

  func show() {
    let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), styleMask: [.titled, .miniaturizable], backing: .buffered, defer: false)
    window.contentView?.addSubview(self.view)
    window.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
    self.centerOnScreen()
  }
  
  @IBAction func ContinueButtonPressed(_ sender: NSButton) {
    moveDozer.player?.pause()
    moveDozer.player = nil
    let window = self.view.window
    window?.orderOut(nil)
  }
  
  
}

extension BoardingScreen {
  
  // Warning: safely unwrap parent window
  func centerOnScreen() {
    let window = self.view.window!
    let centerY = window.screen!.frame.height / 2 - self.view.frame.height / 2
    let centerX = window.screen!.frame.width / 2 - self.view.frame.width / 2
    window.setFrameOrigin(NSPoint(x: centerX, y: centerY))
  }
  
}
