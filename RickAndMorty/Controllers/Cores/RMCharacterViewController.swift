import UIKit

final class RMCharacterViewController: UIViewController {
    
    private let characterView = CharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Characters"
        view.backgroundColor = .systemBackground
        view.addSubview(characterView)
    }
    
    private func configureView() {
        NSLayoutConstraint.activate([
            characterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
