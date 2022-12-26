import Foundation

final class RMService {
    static let shared = RMService()
    
    private init() {}
    
    // generic API  call
    // - Parameters:
    //   - request: request instance
    //   - type: type of object we expect to return back
    //   - completion: callback with data or error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping () -> Void) {
            
        }
}
