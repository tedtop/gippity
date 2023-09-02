import Foundation

struct StorageService: StorageServiceProtocal {
    func fetchDataForKey(key: String) -> String? {
        UserDefaults.standard.string(forKey: key)
    }

    func storeDataForKey(key: String, data: String){
        UserDefaults.standard.setValue(data, forKey: key)
    }
}
