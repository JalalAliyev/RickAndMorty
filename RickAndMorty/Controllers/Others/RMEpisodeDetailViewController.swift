import UIKit

final class RMEpisodeDetailViewController: UIViewController {
    private var viewModel: RMEpisodeDetailViewModel
    
    init(url: URL?) {
        self.viewModel = .init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("RMEpisodeDetailViewController has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        title = "Episode Detail"
    }

}
