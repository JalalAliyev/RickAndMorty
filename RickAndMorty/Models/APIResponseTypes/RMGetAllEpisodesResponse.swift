import Foundation

struct RMGetAllEpisodesResponse: Codable {
    let info: RMGetAllEpisodesInfo
    let results: [RMEpisode]
}

struct RMGetAllEpisodesInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
