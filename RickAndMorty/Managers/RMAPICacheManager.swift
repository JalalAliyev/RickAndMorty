import Foundation

// Manages in memory session scoped API caches
final class RMAPICacheManger {
    private var cacheDictionary: [RMEndpoints: NSCache<NSString, NSData>] = [:]
    
    private var cache = NSCache<NSString, NSDate>()
    
    init() {
        setUpCache()
    }
    
    // MARK: Public methods
    
    public func cacheResponse(for endpoint: RMEndpoints, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return nil
        }
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint: RMEndpoints, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return
        }
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }

    // MARK: Private
    
    private func setUpCache() {
        RMEndpoints.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
}
