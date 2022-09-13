//
//  Crash.swift
//  VTools
//
//  Created by Jarvis on 2022/6/29.
//

import Foundation

typealias SignalHandler = (Int, siginfo_t,Void)
var previousUncaughtExceptionHandler:NSUncaughtExceptionHandler? = nil
var previousSignalExceptionHandler:SignalHandler? = nil
///设置异常监听
public func installUncaughtExceptionHandler() {
    //备份前者的监听
    previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    //注册NS异常监听
    NSSetUncaughtExceptionHandler { exception in
        print("闪退了")
//        NotificationCenter.default.post(name: K.Notification.uncaughtException, object: nil)
        previousUncaughtExceptionHandler?(exception)
    }
    /**
     //注册信号
     如果在运行时遇到意外情况，Swift代码将以SIGTRAP此异常类型终止，例如：
     1.具有nil值的非可选类型
     2.一个失败的强制类型转换
     
     SIGILL    执行了非法指令，一般是可执行文件出现了错误
     SIGTRAP    断点指令或者其他trap指令产生
     SIGABRT    调用abort产生
     SIGBUS    非法地址。比如错误的内存类型访问、内存地址对齐等
     SIGSEGV    非法地址。访问未分配内存、写入没有写权限的内存等
     */
    let signals: Array<Int32> = [SIGABRT,SIGSEGV,SIGBUS,SIGTRAP,SIGILL,SIGHUP,SIGINT,SIGQUIT,SIGFPE,SIGPIPE]
    for signa in signals {
        signal(signa, signalExceptionHandler)
        
//      let source = DispatchSource.makeSignalSource(signal: signa,queue: .global())
//        source.setEventHandler {
//            print("闪退了111")
//            NotificationCenter.default.post(name: K.Notification.uncaughtException, object: nil)
//        }
//        source.resume()
    }
    
//    signal(signa, signalExceptionHandler)
//    signal(SIGABRT, signalExceptionHandler)
//    signal(SIGSEGV, signalExceptionHandler)
//    signal(SIGBUS, signalExceptionHandler)
//    signal(SIGTRAP, signalExceptionHandler)
//    signal(SIGILL, signalExceptionHandler)
//    signal(SIGHUP, signalExceptionHandler)
//    signal(SIGINT, signalExceptionHandler)
//    signal(SIGQUIT, signalExceptionHandler)
//    signal(SIGFPE, signalExceptionHandler)
//    signal(SIGPIPE, signalExceptionHandler)
    
    
}

func signalExceptionHandler(signal:Int32) -> Void {
//    NotificationCenter.default.post(name: K.Notification.uncaughtException, object: nil)
}
