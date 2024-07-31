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
    
    var currentWorkItem: DispatchWorkItem?
    
    @IBAction func onPressSubmit(_ sender: Any) {
        currentWorkItem = DispatchWorkItem(block: { [weak self] in
            
            for index in 0 ... 100 {
                guard let item = self?.currentWorkItem, !item.isCancelled else { return }
                print(index, separator: " ", terminator: " ")
                Thread.sleep(forTimeInterval: 0.1)
            }
        })
        
        guard let workItem = currentWorkItem else {
            return
        }
        
        concurrentQueue.async(execute: workItem)
        
        workItem.notify(queue: concurrentQueue) {
            print("Done")
        }
    }
    
    @IBAction func onPressCancel(_ sender: Any) {
        currentWorkItem?.cancel()
    }
    
    let dispatchGroup = DispatchGroup()
    
    @IBAction func onPressDispatchGroup(_ sender: Any) {
        concurrentQueue.async(group: dispatchGroup) {
            for _ in 0 ... 10 {
                print("🍎", separator: " ", terminator: " ")
                
                Thread.sleep(forTimeInterval: 0.1)
            }
        }
        
        concurrentQueue.async(group: dispatchGroup) {
            for _ in 0 ... 10 {
                print("🍐", separator: " ", terminator: " ")
                
                Thread.sleep(forTimeInterval: 0.2)
            }
        }
        
        serialQueue.async(group: dispatchGroup) {
            for _ in 0 ... 10 {
                print("🫐", separator: " ", terminator: " ")
                
                Thread.sleep(forTimeInterval: 0.3)
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("Done")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

