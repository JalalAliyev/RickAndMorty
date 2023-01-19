import Foundation

protocol RMEpisodeDataRender {
    var name: String { get }
    var episode: String { get }
    var air_date: String { get }
}

final class RMCharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable {
    private let episodeDataUrl: URL?
    private var isFetching = false
    private var dataBlock: ((RMEpisodeDataRender) -> Void)?
    private var epidode: RMEpisode? {
        didSet {
            guard let model = epidode else {
                return
            }
            dataBlock?(model)
        }
    }
    
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
    
    public func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func getEpisode() {
        guard let url = episodeDataUrl,
              let request = RMRequest(url: url), !isFetching else {
            if let model = epidode {
                dataBlock?(model)
            }
            return
        }
        isFetching = true
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let episode):
                DispatchQueue.main.async {
                    self?.epidode = episode
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    
    static func == (
        lhs: RMCharacterEpisodeCollectionViewCellViewModel,
        rhs: RMCharacterEpisodeCollectionViewCellViewModel
    ) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}
