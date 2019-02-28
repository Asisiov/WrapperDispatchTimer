//
//  Timer.swift
//  LiveMetric
//
//  Created by Aleksandr Sisiov on 12/22/18.
//  Copyright © 2018 Provision Lab. All rights reserved.
//

import Foundation

protocol TimerWrapperProtocol {
    var isRun: Bool { get }
    
    func start(_ repeatTime: DispatchTimeInterval, handler: DispatchSourceProtocol.DispatchSourceHandler?)
    func start(_ delay: DispatchTimeInterval, _ repeatTime: DispatchTimeInterval, handler: DispatchSourceProtocol.DispatchSourceHandler?)
    func stop()
}

class TimerWrapper: TimerWrapperProtocol {
    
    // MARK: -
    // MARK: Properties
    private var timer: DispatchSourceTimer?
    private var queue: DispatchQueue?
    private(set) var isRun = false
    
    // MARK: -
    // MARK: Init and Deinit
    init() {
        queue =  DispatchQueue(label: "com.firm.app.timer", attributes: .concurrent)
    }
    
    deinit {
        stop()
        queue = nil
    }
    
    // MARK: -
    // MARK: Public Methods
    func start(_ repeatTime: DispatchTimeInterval, handler: DispatchSourceProtocol.DispatchSourceHandler?) {
        timer = DispatchSource.makeTimerSource(queue: queue)
        
        if let ttimer = timer {
            ttimer.setEventHandler(handler: handler)
            ttimer.schedule(deadline: .now(), repeating: repeatTime, leeway: .milliseconds(100))
            ttimer.resume()
            isRun = true
        }
    }
    
    func start(_ delay: DispatchTimeInterval, _ repeatTime: DispatchTimeInterval, handler: DispatchSourceProtocol.DispatchSourceHandler?) {
        timer = DispatchSource.makeTimerSource(queue: queue)
        
        if let ttimer = timer {
            ttimer.setEventHandler(handler: handler)
            ttimer.schedule(deadline: .now() + delay, repeating: repeatTime, leeway: .milliseconds(100))
            ttimer.resume()
            isRun = true
        }
    }
    
    func stop() {
        isRun = false
        timer?.cancel()
        timer = nil
    }
}
