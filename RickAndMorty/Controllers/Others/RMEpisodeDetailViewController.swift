import UIKit

final class RMEpisodeDetailViewController: UIViewController {
    private var viewModel: RMEpisodeDetailViewModel
    private let episodeDetailView = RMEpisodeDetailView()
    
    init(url: URL?) {
        self.viewModel = RMEpisodeDetailViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("RMEpisodeDetailViewController has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        episodeDetailView.delegate = self
        setupUI()
        viewModel.delegate = self
        viewModel.fetchEpisodeDetails()
    }
    
    private func setupUI() {
        title = "Episode Detail"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        configureView()
    }
    
    private func configureView() {
        view.addSubview(episodeDetailView)
        NSLayoutConstraint.activate([
            episodeDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeDetailView.leftAnchor.constraint(equalTo: view.leftAnchor),
            episodeDetailView.rightAnchor.constraint(equalTo: view.rightAnchor),
            episodeDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    private func didTapShare() {
        print("didTapShare called!")
    }

}

extension RMEpisodeDetailViewController: RMEpisodeDetailViewModelDelegate {
    func didFetchEpisodeDetails() {
        episodeDetailView.configure(with: viewModel)
    }
    
}

extension RMEpisodeDetailViewController: RMEpisodeDetailViewDelegate {
    func rmEmpisodeDetailView(_ detailView: RMEpisodeDetailView, selectedCharacter: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: selectedCharacter))
        vc.title = selectedCharacter.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
