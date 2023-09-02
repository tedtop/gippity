import Foundation
protocol StorageServiceProtocal {
    func fetchDataForKey(key: String) -> String?
    func storeDataForKey(key: String, data: String)
}
