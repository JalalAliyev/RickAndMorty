import Foundation

enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return "Status: \(rawValue)"
        case .unknown:
            return "Status: Unknown"
        }
    }
}
