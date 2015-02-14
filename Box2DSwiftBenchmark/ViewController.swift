/**
Copyright (c) 2015 - Yohei Yoshihara

This software is provided 'as-is', without any express or implied
warranty.  In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
claim that you wrote the original software. If you use this software
in a product, an acknowledgment in the product documentation would be
appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be
misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution.
*/
import UIKit
import Box2D

class ViewController: UIViewController {
  var displayLink: CADisplayLink!
  var startTime: CFTimeInterval = 0
  var endTime: CFTimeInterval = 0
  var count = 0
  var cppTest = true
  let testDuration: CFTimeInterval = 30
  
  @IBOutlet weak var startCppButton: UIButton!
  @IBOutlet weak var startSwiftButton: UIButton!
  
  @IBOutlet weak var cppResultLabel: UILabel!
  @IBOutlet weak var swiftResultLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.whiteColor()
    
    startCppButton.addTarget(self, action: "onStart:", forControlEvents: UIControlEvents.TouchUpInside)
    startSwiftButton.addTarget(self, action: "onStart:", forControlEvents: UIControlEvents.TouchUpInside)
  }
  
  func onStart(sender: UIButton) {
    println("start")
    
    startCppButton.enabled = false
    startSwiftButton.enabled = false
    
    cppTest = sender === startCppButton
    
    if cppTest {
      cppResultLabel.text = "Running (wait \(testDuration) seconds)"
      tumbler_prepare()
    }
    else {
      swiftResultLabel.text = "Running (wait \(testDuration) seconds)"
      tumblerSwift_prepare()
    }
    
    displayLink = CADisplayLink(target: self, selector: "stepCpp")
    displayLink.frameInterval = 1
    displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    startTime = CACurrentMediaTime()
    count = 0
  }
  
  func stepCpp() {
    if cppTest {
      tumbler_step()
    }
    else {
      tumblerSwift_step()
    }
    ++count
    endTime = CACurrentMediaTime()
    if endTime - startTime > testDuration {
      onStopCpp()
    }
  }
  
  func onStopCpp() {
    println("end")
    displayLink.invalidate()
    let fps = Double(count) / (endTime - startTime)
    println("fps = \(fps)")
    if cppTest {
      tumbler_end()
      cppResultLabel.text = "fps = \(fps)"
    }
    else {
      tumblerSwift_end()
      swiftResultLabel.text = "fps = \(fps)"
    }
    startCppButton.enabled = true
    startSwiftButton.enabled = true
  }
}

