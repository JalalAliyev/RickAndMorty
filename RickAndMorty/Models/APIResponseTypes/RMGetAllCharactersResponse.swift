import Foundation

struct RMGetAllCharactersResponse: Codable {
    let info: RMGetAllCharacterInfo
    let results: [RMCharacter]
}

struct RMGetAllCharacterInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
