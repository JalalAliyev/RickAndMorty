import UIKit

final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Characters"
        view.backgroundColor = .systemBackground

        let request = RMRequest(endpoint: .character,
                                queryParameters: [
                                    URLQueryItem(name: "name", value: "rick"),URLQueryItem(name: "status", value: "alive")
                                ]
        )
        
        RMService.shared.execute(request, expecting: String.self) {result in
            switch result {
            case .success(
            }
        }
    }

}
