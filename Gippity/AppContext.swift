import Foundation

struct AppContext {
    let storageService: StorageServiceProtocal
    static func makeContext() -> AppContext {
        let storageService = StorageService()
        return AppContext(storageService: storageService)
    }
}
