//
//  Type.swift
//  VTools
//
//  Created by Jarvis on 2022/3/8.
//

import Foundation

public enum Type: String {
    #if os(iOS)
    case iPhone
    case iPad
    case iPod
    case simulator
    #elseif os(OSX)
    case iMac
    case macMini
    case macPro
    case macBook
    case macBookAir
    case macBookPro
    case xserve
    #endif
    case unknown
}
