import Foundation

final class RMCharacterCollectionViewCellViewModel: Hashable, Equatable {
    public let charName: String
    private let charStatus: RMCharacterStatus
    private let charImageUrl: URL?
    
    init(charName: String,
         charStatus: RMCharacterStatus,
         charImageUrl: URL?
    ) {
        self.charName = charName
        self.charStatus = charStatus
        self.charImageUrl = charImageUrl
    }
    
    public var characterSatusText: String {
        return charStatus.text
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = charImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
    
        RMImageLoader.shared.downloadImage(url, completion: completion)
    }
    
    // MARK: Hashable - if element already exist don't insert
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(charName)
        hasher.combine(charStatus)
        hasher.combine(charImageUrl)
    }
}

