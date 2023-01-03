import Foundation

final class RMService {
    static let shared = RMService()
    
    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
        
    }
    
    private init() {}
    
    // generic API  call
    // - Parameters:
    //   - request: request instance
    //   - type: type of object we expect to return back
    //   - completion: callback with data or error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) {
            guard let urlRequest = self.request(from: request) else {
                completion(.failure(RMServiceError.failedToCreateRequest))
                return
            }
            URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? RMServiceError.failedToGetData))
                    return
                }
                // Decode response data
                do {
                    let result = try JSONDecoder().decode(type.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }.resume()
            
        }
    
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        
        return request
    }
}
