//
//  GCDTimer.swift
//  SmartCampus
//
//  Created by Jarvis on 2022/7/26.
//

import Foundation

public class GCDTimer: NSObject {
    public static let `default` = GCDTimer()
    
    private var timer: DispatchSourceTimer?
    private var closure: (()-> Void)?
    deinit {
        timer?.cancel()
    }
    
    // 暂停定时器
    public func stop() {
        timer?.suspend()
    }
    
    // 重启定时器
    public func restart() {
        timer?.resume()
    }
    
    // 清除定时器
    public func invalidate() {
        closure = nil
        timer?.cancel()
    }
    
    // 主线程设置CGD定时器
    // startIterval: 定时第一次启动时间
    // interval 时间
    // isRepeat 是否循环
    // block 执行返回
    public func setTimeInterval(startIterval: CGFloat, interval: Int, isRepeat: Bool = false, block: @escaping  () -> Void) {
        invalidate()
        closure = block
        // 默认在主队列中调度使用
        timer = DispatchSource.makeTimerSource()
        
        var timeType: DispatchTimeInterval = .never
        if isRepeat {
            timeType = .seconds(interval)
        }
        timer?.schedule(deadline: .now() + startIterval , repeating: timeType, leeway: .nanoseconds(1))
        
        timer?.setEventHandler {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                // 执行任务
                self.closure?()
            }
        }
        
        timer?.setRegistrationHandler(handler: {
            DispatchQueue.main.async {
                // Timer开始工作了
            }
        })
//        timer?.activate()
        timer?.resume()
    }
    
    // 线程设置CGD定时器
    // ztimer 对应线程
    // interval 时间
    // isRepeat 是否循环
    // block 执行返回
    public func setTimeInterval(ztimer: DispatchSourceTimer, interval: Int, isRepeat: Bool = false, block: @escaping  () -> Void) {
        timer = ztimer

        var timeType: DispatchTimeInterval = .never
        if isRepeat {
            timeType = .seconds(interval)
        }
        timer?.schedule(deadline: DispatchTime.now(), repeating: timeType, leeway: .nanoseconds(1))
        
        timer?.setEventHandler {
            DispatchQueue.main.async {
                // 执行任务
                block()
            }
        }
        
        timer?.setRegistrationHandler(handler: {
            DispatchQueue.main.async {
                // Timer开始工作了
            }
        })
//        timer?.activate()
        timer?.resume()
    }
    
    
}

