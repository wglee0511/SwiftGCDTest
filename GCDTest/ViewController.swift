//
//  ViewController.swift
//  GCDTest
//
//  Created by racoon on 7/31/24.
//

import UIKit

let SERIAL_QUEUE = "SERIAL_QUEUE"
let CONCURRENT_QUEUE = "CONCURRENT_QUEUE"

class ViewController: UIViewController {
    
    let serialQueue = DispatchQueue(label: SERIAL_QUEUE)
    let concurrentQueue = DispatchQueue(label: CONCURRENT_QUEUE, attributes: .concurrent)
    
    @IBAction func onPressSync(_ sender: Any) {
        concurrentQueue.sync {
            for _ in 0..<3 {
                print("Sync")
            }
            print("# Point 1")
        }
        print("# Point 2")
    }
    
    
    @IBAction func onPressAsync(_ sender: Any) {
        concurrentQueue.async {
            for _ in 0..<3 {
                print("Async")
            }
            print("# Point 1")
        }
        print("# Point 2")
    }
    
    
    @IBAction func onPressDelay(_ sender: Any) {
        let delayTime = DispatchTime.now() + 3
        
        concurrentQueue.asyncAfter(deadline: delayTime) {
            print("# Point 1")
        }
        
        print("# Point 2")
    }
    
    @IBAction func onPressConcurrent(_ sender: Any) {
        var startTime = Date.now
        
        for index in 0 ... 50 {
            print(index, terminator: " ")
            
            Thread.sleep(forTimeInterval: 0.1)
        }

        print()
        
        var endTime = Date.now
        
        var timeDifference = endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
        
        print("Serial: \(timeDifference)")
        
        
        
        startTime = Date.now
        
        DispatchQueue.concurrentPerform(iterations: 50) { index in print(index, terminator: " ")
            Thread.sleep(forTimeInterval: 0.1)
        }

        print()
        
        endTime = Date.now
        
        timeDifference = endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
        
        print("Concurrent: \(timeDifference)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

