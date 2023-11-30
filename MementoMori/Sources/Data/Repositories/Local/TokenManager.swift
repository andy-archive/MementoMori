//
//  TokenManager.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/29/23.
//

import Foundation

final class TokenManager: KeychainManager {
    
    private let keySecurityClass = kSecClassGenericPassword
    
    private func logError(_ status: OSStatus) {
        let description = SecCopyErrorMessageString(status, nil)
        print(description ?? "Keychain ERROR.")
    }
    
    private func update(key: KeyType, value: Data) -> Bool {
        let updateQuery: [CFString: Any] = [kSecValueData: value]
        let searchQuery: [CFString: Any] = [
            kSecClass: keySecurityClass,
            kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemUpdate(searchQuery as CFDictionary, updateQuery as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            logError(status)
            return false
        }
    }
    
    func save(key: KeyType, value: String) -> Bool {
        guard let valueData = value.data(using: .utf8) else { return false }
        
        let query: [CFString: Any] = [
            kSecClass: keySecurityClass,
            kSecAttrAccount: key.rawValue,
            kSecValueData: valueData
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return update(key: key, value: valueData)
        } else {
            logError(status)
            return false
        }
    }
    
    func verify(key: KeyType) -> String? {
        let query: [CFString: Any] = [
            kSecClass: keySecurityClass,
            kSecAttrAccount: key.rawValue,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        
        var item: CFTypeRef?
        
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else {
            logError(status)
            return nil
        }
        
        guard
            let existingItem = item as? [String: Any],
            let data = existingItem[kSecValueData as String] as? Data,
            let token = String(data: data, encoding: .utf8)
        else {
            return nil
        }
        
        return token
    }

    func delete(key: KeyType) -> Bool {
        let searchQuery: [CFString: Any] = [
            kSecClass: keySecurityClass,
            kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemDelete(searchQuery as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            logError(status)
            return false
        }
    }
}
