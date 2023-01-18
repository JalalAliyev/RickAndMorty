import UIKit

final class RMEpisodeDetailViewController: UIViewController {
    var url: URL?
    
    init(url: URL?) {
        self.url = url
        
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
