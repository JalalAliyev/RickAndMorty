import Foundation

final class RMEpisodeDetailViewModel {
    private var endpointUrl: URL?
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        
        fetchEpisodeDetails()
    }
    
    
    private func fetchEpisodeDetails() {
        guard let url = endpointUrl, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { result in
            switch result {
            case .success(let data):
                print(String(describing: data))
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    
}
