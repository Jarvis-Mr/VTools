//
//  Hex.swift
//  AFNetworking
//
//  Created by Jarvis on 2021/12/21.
//

import Foundation

extension Data {
    //        var string = ""
    //        let buffer: [UInt8] = [UInt8](self)
    //        for byte in buffer {
    //            let hex = String(format: "%x", byte & 0xff)
    //            if hex.count == 2 {
    //                string.append(contentsOf: hex)
    //            } else {
    //                string.append(contentsOf: String(format: "0%@", hex))
    //            }
    //        }
    //
    //        LLog(string)
    //        return string
    func subData() ->Data {
        return self.subdata(in: 0..<8)
    }
    
    /// data转 十六进制字符串
    /// - Returns: string
    func hexString() -> String {
        return map { String(format: "%02x", $0) }.joined()
        
    }
}

extension String {
    /**
     var hexStr1 = ""
     if self.count % 2 != 0 {
         hexStr1 = "0" + self
     }else {
         hexStr1 = self
     }
     let bytes = self.bytes(from: hexStr1)
     return Data(bytes: bytes)
     */
    
    
    /// 十六进制字符串转Data
    /// - Returns: data
     func hexToData() -> Data? {
        guard self.count > 0, self.count % 2 == 0 else {return nil}
        var data = Data(capacity: self.count/2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
            regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        guard data.count > 0 else { return nil }
        return data
    }
}

extension Int {
     func toHex() -> String {
        return String(format: "%02x", self)
    }
}
