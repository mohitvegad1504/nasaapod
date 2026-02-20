import Foundation
import Security

final class KeychainManager {

    // MARK: - Singleton
    static let shared = KeychainManager()
    private init() { }

    // MARK: - Save String
    func save(_ key: String, value: String, accessibility: CFString = kSecAttrAccessibleWhenUnlocked) {
        guard let data = value.data(using: .utf8) else { return }
        saveData(key: key, data: data, accessibility: accessibility)
    }

    // MARK: - Read String
    func read(_ key: String) -> String? {
        guard let data = readData(key: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    // MARK: - Save Codable Object
    func save<T: Codable>(_ key: String, object: T, accessibility: CFString = kSecAttrAccessibleWhenUnlocked) {
        do {
            let data = try JSONEncoder().encode(object)
            saveData(key: key, data: data, accessibility: accessibility)
        } catch {
            print("Keychain encode error: \(error)")
        }
    }

    // MARK: - Read Codable Object
    func read<T: Codable>(_ key: String, type: T.Type) -> T? {
        guard let data = readData(key: key) else { return nil }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Keychain decode error: \(error)")
            return nil
        }
    }

    // MARK: - Delete
    func delete(_ key: String) {
        let query = keychainQuery(key: key)
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            print("Keychain delete error: \(status)")
        }
    }

    // MARK: - Private Helpers
    private func saveData(key: String, data: Data, accessibility: CFString) {
        let query = keychainQuery(key: key, accessibility: accessibility)
        
        // If item exists, update
        if SecItemCopyMatching(query as CFDictionary, nil) == errSecSuccess {
            let attributesToUpdate: [String: Any] = [kSecValueData as String: data]
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                print("Keychain update error: \(status)")
            }
        } else {
            // Add new item
            var newQuery = query
            newQuery[kSecValueData as String] = data
            let status = SecItemAdd(newQuery as CFDictionary, nil)
            if status != errSecSuccess {
                print("Keychain add error: \(status)")
            }
        }
    }

    private func readData(key: String) -> Data? {
        var query = keychainQuery(key: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess {
            return result as? Data
        } else if status != errSecItemNotFound {
            print("Keychain read error: \(status)")
        }
        return nil
    }

    private func keychainQuery(key: String, accessibility: CFString = kSecAttrAccessibleWhenUnlocked) -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrAccessible as String: accessibility
        ]
    }
}
