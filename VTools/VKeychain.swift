//
//  VKeychain.swift
//  VTools
//
//  Created by Jarvis on 2022/2/10.
//

import Foundation
import Security


public class VKeychain: NSObject {
    enum KeychainError: Error {
        // Attempted read for an item that does not exist.
        case itemNotFound
        
        // Attempted save to override an existing item.
        // Use update instead of save to update existing items
        case duplicateItem
        
        // A read of an item in any format other than Data
        case invalidItemFormat
        
        // Any operation result status than errSecSuccess
        case unexpectedStatus(OSStatus)
        
        var string: String {
            get {
                switch self {
                case .itemNotFound:
                    return "钥匙不存在"
                case .duplicateItem:
                    return "钥匙已经存在，不能使用save 操作"
                case .invalidItemFormat:
                    return "数据格式有问题"
                case .unexpectedStatus(let oSStatus):
                    return "操作失败:\(oSStatus)"
                }
            }
        }
    }
    
    @Defaults("label", defaultValue:"v_uuid")
    static var label: String
    
    @Defaults("tag", defaultValue:"101")
    static var tag: String
    
    public static func initUUID() {
        
        do {
           _ = try getKeychain()
            
        } catch let err {
            guard let err = err as? KeychainError else {return}
            LLog(err.string)
            
            let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "").uppercased()
            guard let data = uuid.data(using: .utf8) else {return}
            
            do {
                try saveKeychain(key: data)
            } catch _ {
                
            }
        }
         
    }
    
    /// 获取钥匙
    /// - Returns: 返回钥匙
    public static func getKeychain() throws -> String? {
        var keychainQuery = keychainQuery()
        // 设置获取数据类型
        keychainQuery[kSecReturnData as String] = kCFBooleanTrue
        // 获取的数量， one or all
        keychainQuery[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(
            keychainQuery as CFDictionary,
            &itemCopy
        )
        
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }

        guard let data = itemCopy as? Data else {
            throw KeychainError.invalidItemFormat
        }
        
        return String(data: data, encoding: .utf8)?.uppercased()
    }
    
    
    /// 创建钥匙的配置
    /// - Parameters:
    ///   - lab: 描述
    ///   - tag: 标记
    /// - Returns: 配置结果
    public static func keychainQuery() -> [String: AnyObject] {
        return [kSecClass as String: kSecClassKey as AnyObject, ///类型
                kSecAttrApplicationLabel as String: label.data(using: .utf8) as AnyObject, /// 描述
                kSecAttrApplicationTag as String: tag.data(using: .utf8) as AnyObject] /// 标记
    }
    
    /// 保存钥匙
    /// - Parameter key: 钥匙
    public static func saveKeychain(key: Data) throws {
        var keychainQuery = keychainQuery()
        keychainQuery[kSecValueData as String] = key as AnyObject
        // SecItemAdd attempts to add the item identified by
        // the query to keychain
        let status = SecItemAdd(
            keychainQuery as CFDictionary,
            nil
        )

        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    
    /// 删除钥匙
    public static func deleteKeychain() throws {
        let keychainQuery = keychainQuery()
        let status = SecItemDelete(keychainQuery as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    static func save(password: Data, service: String, account: String) throws {

        let query: [String: AnyObject] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            // uniquely identify the item to save in Keychain
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            
            // kSecValueData is the item value to save
            kSecValueData as String: password as AnyObject
        ]
        
        // SecItemAdd attempts to add the item identified by
        // the query to keychain
        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )

        // errSecDuplicateItem is a special case where the
        // item identified by the query already exists. Throw
        // duplicateItem so the client can determine whether
        // or not to handle this as an error
        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }

        // Any status other than errSecSuccess indicates the
        // save operation failed.
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    static func update(password: Data, service: String, account: String) throws {
        let query: [String: AnyObject] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            // uniquely identify the item to update in Keychain
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        
        // attributes is passed to SecItemUpdate with
        // kSecValueData as the updated item value
        let attributes: [String: AnyObject] = [
            kSecValueData as String: password as AnyObject
        ]
        
        // SecItemUpdate attempts to update the item identified
        // by query, overriding the previous value
        let status = SecItemUpdate(
            query as CFDictionary,
            attributes as CFDictionary
        )

        // errSecItemNotFound is a special status indicating the
        // item to update does not exist. Throw itemNotFound so
        // the client can determine whether or not to handle
        // this as an error
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }

        // Any status other than errSecSuccess indicates the
        // update operation failed.
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    static func readPassword(service: String, account: String) throws -> Data {
        let query: [String: AnyObject] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            // uniquely identify the item to read in Keychain
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            
            // kSecMatchLimitOne indicates keychain should read
            // only the most recent item matching this query
            kSecMatchLimit as String: kSecMatchLimitOne,

            // kSecReturnData is set to kCFBooleanTrue in order
            // to retrieve the data for the item
            kSecReturnData as String: kCFBooleanTrue
        ]

        // SecItemCopyMatching will attempt to copy the item
        // identified by query to the reference itemCopy
        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &itemCopy
        )

        // errSecItemNotFound is a special status indicating the
        // read item does not exist. Throw itemNotFound so the
        // client can determine whether or not to handle
        // this case
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        // Any status other than errSecSuccess indicates the
        // read operation failed.
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }

        // This implementation of KeychainInterface requires all
        // items to be saved and read as Data. Otherwise,
        // invalidItemFormat is thrown
        guard let password = itemCopy as? Data else {
            throw KeychainError.invalidItemFormat
        }

        return password
    }
    
    static func deletePassword(service: String, account: String) throws {
        let query: [String: AnyObject] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            // uniquely identify the item to delete in Keychain
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]

        // SecItemDelete attempts to perform a delete operation
        // for the item identified by query. The status indicates
        // if the operation succeeded or failed.
        let status = SecItemDelete(query as CFDictionary)

        // Any status other than errSecSuccess indicates the
        // delete operation failed.
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}
