import Foundation

protocol RMEpisodeDetailViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewModel {
    
    // MARK: Private variable
    private var endpointUrl: URL?
    
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()
    
    enum SectionType {
        case info(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [RMCharacterCollectionViewCellViewModel])
    }
    
    // MARK: Public variable
    weak public var delegate: RMEpisodeDetailViewModelDelegate?
    
    public private(set) var cellViewModels: [SectionType] = []
    
    // MARK: init
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    // MARK: create view models for each section case
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {return}
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        var notCreatedDate = "Undefind"
        if let createdDate = Self.dateFormatter.date(from: episode.created) {
            notCreatedDate = Self.shortDateFormatter.string(from: createdDate)
        }
        cellViewModels = [
            .info(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: notCreatedDate)
            ]),
            .characters(viewModels: characters.compactMap({
                return .init(
                    charName: $0.name,
                    charStatus: $0.status,
                    charImageUrl: URL(string: $0.image)
                )
            }))
        ]
    }
    
    // MARK: Public
    
    // return character for the given index path
    public func character(at indexPath: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[indexPath]
    }
    
    // MARK: Fetch episode backend model
    
    public func fetchEpisodeDetails() {
        guard let url = endpointUrl, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) {[weak self] result in
            switch result {
            case .success(let data):
                self?.fetchRelatedCharacters(episode: data)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    private func fetchRelatedCharacters(episode: RMEpisode) {
        let charactersUrl: [URL] = episode.characters.compactMap({
            return URL(string: $0)
        })
        
        let requests: [RMRequest] = charactersUrl.compactMap({
            return RMRequest(url: $0)
        })
        
        // n number of paralel requests
        // Notified once all done
        
        let group = DispatchGroup()
        var characters = [RMCharacter]()
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure(_):
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (
                episode: episode,
                characters: characters
            )
        }
        
    }
    
}
