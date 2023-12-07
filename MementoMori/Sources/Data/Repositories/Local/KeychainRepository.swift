//
//  KeychainRepository.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/29/23.
//

import Foundation

final class KeychainRepository: KeychainRepositoryProtocol {
    
    private let keySecurityClass = kSecClassGenericPassword
    
    //MARK: - (1) logError - private functions
    private func logError(_ status: OSStatus) {
        let description = SecCopyErrorMessageString(status, nil)
        print(description ?? "Keychain ERROR.")
    }

    //MARK: - (2) update - private functions
    private func update(account: String, value: Data) -> Bool {
        let updateQuery: [CFString: Any] = [kSecValueData: value]
        let searchQuery: [CFString: Any] = [
            kSecClass: keySecurityClass,
            kSecAttrAccount: account
        ]
        let status = SecItemUpdate(searchQuery as CFDictionary, updateQuery as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            logError(status)
            return false
        }
    }
    
    //MARK: - (1) save - KeychainRepositoryProtocol
    func save(key: String, value: String, type: KeyType) -> Bool {
        guard let valueData = value.data(using: .utf8) else { return false }
        
        let account = key + type.rawValue
        let query: [CFString: Any] = [
            kSecClass: keySecurityClass,
            kSecAttrAccount: account,
            kSecValueData: valueData
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return update(account: account, value: valueData)
        } else {
            logError(status)
            return false
        }
    }
    
    //MARK: - (2) find - KeychainRepositoryProtocol
    func find(key: String, type: KeyType) -> String? {
        let account = key + type.rawValue
        let query: [CFString: Any] = [
            kSecClass: keySecurityClass,
            kSecAttrAccount: account,
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
    
    //MARK: - (3) delete - KeychainRepositoryProtocol
    func delete(key: String, type: KeyType) -> Bool {
        let account = key + type.rawValue
        let searchQuery: [CFString: Any] = [
            kSecClass: keySecurityClass,
            kSecAttrAccount: account
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
